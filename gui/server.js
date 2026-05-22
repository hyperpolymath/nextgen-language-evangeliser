// SPDX-License-Identifier: MPL-2.0

const projectRootUrl = new URL("../", import.meta.url)
const projectRoot = decodeURIComponent(projectRootUrl.pathname)
const decoder = new TextDecoder()

const contentTypes = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
}

function argValue(name, fallback) {
  const index = Deno.args.indexOf(name)
  if (index === -1 || index + 1 >= Deno.args.length) {
    return fallback
  }
  return Deno.args[index + 1]
}

async function exists(path) {
  try {
    await Deno.stat(path)
    return true
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      return false
    }
    throw error
  }
}

async function ensureCompiled() {
  const compiledEntry = new URL("../src/Cli.res.js", import.meta.url)
  if (await exists(compiledEntry)) {
    return
  }

  const command = new Deno.Command(Deno.execPath(), {
    args: ["run", "--no-lock", "-A", "npm:rescript", "build"],
    cwd: projectRoot,
    stdout: "piped",
    stderr: "piped",
  })
  const output = await command.output()
  if (!output.success) {
    const detail = decoder.decode(output.stderr) ||
      decoder.decode(output.stdout)
    throw new Error(`ReScript build failed:\n${detail}`)
  }
}

await ensureCompiled()

const [Analyser, Output, Patterns, Types, Glyphs] = await Promise.all([
  import(new URL("../src/Analyser.res.js", import.meta.url).href),
  import(new URL("../src/Output.res.js", import.meta.url).href),
  import(new URL("../src/Patterns.res.js", import.meta.url).href),
  import(new URL("../src/Types.res.js", import.meta.url).href),
  import(new URL("../src/Glyphs.res.js", import.meta.url).href),
])

const viewTags = {
  raw: "RAW",
  folded: "FOLDED",
  glyphed: "GLYPHED",
}

const difficultyTags = {
  beginner: "Beginner",
  intermediate: "Intermediate",
  advanced: "Advanced",
}

function json(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json; charset=utf-8" },
  })
}

function targetFrom(value) {
  return Types.stringToTargetLang(String(value || "affinescript")) ||
    "AffineScript"
}

function viewFrom(value) {
  return viewTags[String(value || "raw").toLowerCase()] || "RAW"
}

function patternsForDifficulty(value) {
  const key = String(value || "all").toLowerCase()
  const tag = difficultyTags[key]
  return tag ? Patterns.getPatternsByDifficulty(tag) : undefined
}

function analyseSource(payload) {
  const code = String(payload.code || "")
  const target = targetFrom(payload.target)
  const view = viewFrom(payload.view)
  const format = String(payload.format || "markdown")
  const filteredPatterns = patternsForDifficulty(payload.difficulty)
  const result = filteredPatterns
    ? Analyser.analyseWithPatterns(code, filteredPatterns)
    : Analyser.analyse(code)

  const matches = result.matches.map((match) => {
    const pattern = match.pattern
    const effectiveTarget = Types.patternEffectiveTarget(pattern, target)
    return {
      id: pattern.id,
      name: pattern.name,
      category: Types.categoryToString(pattern.category),
      difficulty: Types.difficultyToString(pattern.difficulty),
      confidence: Math.round(match.confidence * 100),
      glyphs: pattern.glyphs,
      tags: pattern.tags,
      startLine: match.startLine,
      endLine: match.endLine,
      detectedCode: match.code,
      jsExample: pattern.jsExample,
      target: Types.targetLangLabel(effectiveTarget),
      targetCode: Types.patternCodeFor(pattern, target),
      fallback: effectiveTarget !== target,
      narrative: pattern.narrative,
      learningObjectives: pattern.learningObjectives,
      bestPractices: pattern.bestPractices,
    }
  })

  return {
    summary: Analyser.summarise(result),
    matchCount: result.matches.length,
    uniquePatternCount: new Set(matches.map((match) => match.id)).size,
    totalPatterns: result.totalPatterns,
    coveragePercentage: Number(result.coveragePercentage.toFixed(1)),
    difficulty: Types.difficultyToString(result.difficulty),
    analysisTimeMs: result.analysisTime,
    target: Types.targetLangLabel(target),
    view,
    matches,
    suggestions: result.suggestedNextPatterns.map((pattern) => ({
      id: pattern.id,
      name: pattern.name,
      category: Types.categoryToString(pattern.category),
      difficulty: Types.difficultyToString(pattern.difficulty),
    })),
    rendered: {
      markdown: Output.format(result, view, "markdown", target),
      plain: Output.format(result, view, "plain", target),
      selected: Output.format(result, view, format, target),
    },
  }
}

function patternCatalogue() {
  return Patterns.patternLibrary.map((pattern) => ({
    id: pattern.id,
    name: pattern.name,
    category: Types.categoryToString(pattern.category),
    difficulty: Types.difficultyToString(pattern.difficulty),
    confidence: Math.round(pattern.confidence * 100),
    glyphs: pattern.glyphs,
    targets: pattern.targets.map((target) => Types.targetLangLabel(target.language)),
    celebrate: pattern.narrative.celebrate,
  }))
}

function stats() {
  const stats = Patterns.getPatternStats()
  return {
    total: stats.total,
    byCategory: stats.byCategory,
    byDifficulty: stats.byDifficulty,
  }
}

async function staticResponse(pathname) {
  const routes = {
    "/": "app.html",
    "/app.js": "app.js",
  }
  const file = routes[pathname]
  if (!file) {
    return undefined
  }
  const fileUrl = new URL(file, import.meta.url)
  const body = await Deno.readFile(fileUrl)
  const suffix = file.slice(file.lastIndexOf("."))
  return new Response(body, {
    headers: {
      "content-type": contentTypes[suffix] || "application/octet-stream",
    },
  })
}

async function handler(request) {
  const url = new URL(request.url)
  try {
    if (request.method === "GET") {
      const staticFile = await staticResponse(url.pathname)
      if (staticFile) {
        return staticFile
      }
      if (url.pathname === "/api/patterns") {
        return json({ patterns: patternCatalogue(), stats: stats() })
      }
      if (url.pathname === "/api/legend") {
        return json({ legend: Glyphs.createGlyphLegend() })
      }
    }

    if (request.method === "POST" && url.pathname === "/api/analyse") {
      const payload = await request.json()
      return json(analyseSource(payload))
    }

    return json({ error: "Not found" }, 404)
  } catch (error) {
    console.error(error)
    return json({ error: error.message || String(error) }, 500)
  }
}

function openBrowser(url) {
  const candidates = [
    ["sensible-browser", url],
    ["gio", "open", url],
  ]
  for (const [command, ...args] of candidates) {
    try {
      new Deno.Command(command, {
        args,
        stdout: "null",
        stderr: "null",
      }).spawn()
      return true
    } catch {
      // Try the next opener.
    }
  }
  return false
}

const requestedPort = Number(
  argValue("--port", Deno.env.get("EVANGELISER_GUI_PORT") || "8765"),
)
const hostname = argValue("--host", "127.0.0.1")
let server
let port = requestedPort

for (let attempt = 0; attempt < 20; attempt += 1) {
  try {
    port = requestedPort + attempt
    server = Deno.serve({ hostname, port, onListen: () => {} }, handler)
    break
  } catch (error) {
    if (String(error.message || error).includes("Address already in use")) {
      continue
    }
    throw error
  }
}

if (!server) {
  throw new Error(
    `No free port found from ${requestedPort} to ${requestedPort + 19}`,
  )
}

const url = `http://${hostname}:${port}/`
console.log(`Nextgen Languages Evangeliser GUI: ${url}`)

if (Deno.args.includes("--open")) {
  setTimeout(() => {
    const opened = openBrowser(url)
    if (!opened) {
      console.log(`Open this URL manually: ${url}`)
    }
  }, 250)
}

await server.finished
