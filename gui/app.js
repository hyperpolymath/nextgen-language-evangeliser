// SPDX-License-Identifier: MPL-2.0

const sampleSource = `async function loadUser(id) {
  try {
    const response = await fetch(\`/api/users/\${id}\`);
    const user = await response.json();
    const name = user ? user.name : "Guest";
    return user?.settings?.theme || name;
  } catch (error) {
    console.error(error);
    return null;
  }
}`

const state = {
  activeTab: "findings",
  analysis: null,
  patterns: [],
  legend: "",
}

const source = document.querySelector("#source")
const target = document.querySelector("#target")
const view = document.querySelector("#view")
const difficulty = document.querySelector("#difficulty")
const analyseButton = document.querySelector("#analyse")
const sampleButton = document.querySelector("#sample")
const clearButton = document.querySelector("#clear")
const statusPill = document.querySelector("#status")
const tabPanel = document.querySelector("#tabPanel")

source.value = sampleSource

function setStatus(text, kind = "") {
  statusPill.textContent = text
  statusPill.className = `pill ${kind}`.trim()
}

function node(tag, options = {}, children = []) {
  const element = document.createElement(tag)
  for (const [key, value] of Object.entries(options)) {
    if (key === "className") {
      element.className = value
    } else if (key === "text") {
      element.textContent = value
    } else if (key.startsWith("on")) {
      element.addEventListener(key.slice(2).toLowerCase(), value)
    } else {
      element.setAttribute(key, value)
    }
  }
  for (const child of children) {
    element.append(child)
  }
  return element
}

function codeBlock(label, text) {
  return node("div", { className: "code-block" }, [
    node("label", { text: label }),
    node("pre", {}, [node("code", { text })]),
  ])
}

function updateStats() {
  const analysis = state.analysis
  document.querySelector("#statMatches").textContent = analysis?.matchCount ??
    0
  document.querySelector("#statUnique").textContent = analysis?.uniquePatternCount ?? 0
  document.querySelector("#statCoverage").textContent = analysis
    ? `${analysis.coveragePercentage}%`
    : "0%"
  document.querySelector("#statDifficulty").textContent = analysis?.difficulty ?? "-"
}

function renderFindings() {
  if (!state.analysis) {
    return node("div", { className: "empty", text: "No analysis yet." })
  }

  const children = [
    node("p", { className: "summary", text: state.analysis.summary }),
  ]

  if (state.analysis.matches.length === 0) {
    children.push(
      node("div", { className: "empty", text: "No patterns detected." }),
    )
    return node("div", {}, children)
  }

  for (const match of state.analysis.matches) {
    const meta = [
      node("span", { className: "pill good", text: `${match.confidence}%` }),
      node("span", { className: "pill", text: match.difficulty }),
      node("span", { className: "pill", text: match.category }),
    ]
    if (match.fallback) {
      meta.push(
        node("span", {
          className: "pill warn",
          text: `fallback ${match.target}`,
        }),
      )
    } else {
      meta.push(node("span", { className: "pill", text: match.target }))
    }

    children.push(
      node("article", { className: "finding" }, [
        node("div", { className: "finding-header" }, [
          node("div", {}, [
            node("div", { className: "glyphs", text: match.glyphs.join(" ") }),
            node("strong", { text: match.name }),
          ]),
          node("div", { className: "meta" }, meta),
        ]),
        node("div", { className: "finding-grid" }, [
          codeBlock("JavaScript", match.jsExample),
          codeBlock(match.target, match.targetCode),
          node("div", { className: "narrative" }, [
            node("label", { text: "Narrative" }),
            node("div", { className: "narrative-list" }, [
              node("p", { text: match.narrative.celebrate }),
              node("p", { text: match.narrative.better }),
              node("p", { text: match.narrative.safety }),
              node("p", { text: match.narrative.example }),
            ]),
          ]),
        ]),
      ]),
    )
  }

  return node("div", {}, children)
}

function renderPatterns() {
  if (state.patterns.length === 0) {
    return node("div", {
      className: "empty",
      text: "Pattern catalogue unavailable.",
    })
  }

  return node(
    "div",
    { className: "catalogue" },
    state.patterns.map((pattern) =>
      node("article", { className: "pattern" }, [
        node("div", { className: "pattern-header" }, [
          node("div", {}, [
            node("div", {
              className: "glyphs",
              text: pattern.glyphs.join(" "),
            }),
            node("strong", { text: pattern.name }),
          ]),
          node("span", { className: "pill", text: `${pattern.confidence}%` }),
        ]),
        node("div", { className: "pattern-body" }, [
          node("p", { text: pattern.celebrate }),
          node("div", { className: "meta" }, [
            node("span", { className: "pill", text: pattern.category }),
            node("span", { className: "pill", text: pattern.difficulty }),
            node("span", {
              className: "pill",
              text: pattern.targets.join(", "),
            }),
          ]),
        ]),
      ])
    ),
  )
}

function renderLegend() {
  return node("pre", { className: "legend-output" }, [
    node("code", { text: state.legend || "Legend unavailable." }),
  ])
}

function renderExport() {
  const text = state.analysis?.rendered?.markdown || ""
  return node("pre", { className: "export-output" }, [
    node("code", { text: text || "No output yet." }),
  ])
}

function renderTab() {
  document.querySelectorAll(".tab").forEach((tab) => {
    tab.setAttribute(
      "aria-selected",
      String(tab.dataset.tab === state.activeTab),
    )
  })

  tabPanel.replaceChildren(
    state.activeTab === "findings"
      ? renderFindings()
      : state.activeTab === "patterns"
      ? renderPatterns()
      : state.activeTab === "legend"
      ? renderLegend()
      : renderExport(),
  )
}

async function analyse() {
  analyseButton.disabled = true
  setStatus("Analysing")
  try {
    const response = await fetch("/api/analyse", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        code: source.value,
        target: target.value,
        view: view.value,
        difficulty: difficulty.value,
        format: "markdown",
      }),
    })
    const body = await response.json()
    if (!response.ok) {
      throw new Error(body.error || "Analysis failed")
    }
    state.analysis = body
    state.activeTab = "findings"
    updateStats()
    renderTab()
    setStatus("Complete", "good")
  } catch (error) {
    setStatus("Failed", "warn")
    tabPanel.replaceChildren(
      node("div", { className: "empty", text: error.message }),
    )
  } finally {
    analyseButton.disabled = false
  }
}

async function loadCatalogue() {
  const [patternsResponse, legendResponse] = await Promise.all([
    fetch("/api/patterns"),
    fetch("/api/legend"),
  ])
  if (patternsResponse.ok) {
    const body = await patternsResponse.json()
    state.patterns = body.patterns
  }
  if (legendResponse.ok) {
    const body = await legendResponse.json()
    state.legend = body.legend
  }
}

analyseButton.addEventListener("click", analyse)
sampleButton.addEventListener("click", () => {
  source.value = sampleSource
  analyse()
})
clearButton.addEventListener("click", () => {
  source.value = ""
  state.analysis = null
  updateStats()
  renderTab()
  setStatus("Idle")
})

for (const control of [target, view, difficulty]) {
  control.addEventListener("change", analyse)
}

document.querySelectorAll(".tab").forEach((tab) => {
  tab.addEventListener("click", () => {
    state.activeTab = tab.dataset.tab
    renderTab()
  })
})

await loadCatalogue()
renderTab()
analyse()
