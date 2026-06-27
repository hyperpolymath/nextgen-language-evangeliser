// SPDX-License-Identifier: MPL-2.0
// Correspondence multi-pane workspace — browser logic.
//
// Loads cartridge facts from /api/cartridges and presents them as a 3-pane
// correspondence explorer (index · forms · classification) with five overlay
// view-layers (side-by-side / focus / glyph / blocks / raw). Classify, don't
// translate: each correspondence carries its CorrespondenceKind, residue,
// per-stratum verdicts, and a no-shame narrative.

const KIND = {
  "cognate":           { glyph: "🤝", label: "Cognate",           pedagogy: "Transfer directly",   cls: "k-cognate",  blurb: "Same idea — your intuition carries over." },
  "false-friend":      { glyph: "🎭", label: "False friend",      pedagogy: "Flag the trap",       cls: "k-false",    blurb: "Looks familiar; behaves differently." },
  "antonym":           { glyph: "🔄", label: "Antonym",           pedagogy: "Remap the intuition", cls: "k-antonym",  blurb: "Related but inverted — flip your expectation." },
  "alien-realization": { glyph: "🛸", label: "Alien realization", pedagogy: "Bridge with effort",  cls: "k-alien",    blurb: "Same goal, unfamiliar machinery." },
  "novel":             { glyph: "✨", label: "Novel",             pedagogy: "Teach de novo",       cls: "k-novel",    blurb: "No prior anchor — learn it fresh." },
  "vanished":          { glyph: "👻", label: "Vanished",          pedagogy: "Un-learn / re-route", cls: "k-vanished", blurb: "A habit to drop — it's gone here." },
};
const RESIDUE = {
  "none":          { glyph: "∅",  label: "none (true isomorphism)" },
  "inverted":      { glyph: "🔃", label: "inverted" },
  "lossy":         { glyph: "〜", label: "lossy" },
  "absent-source": { glyph: "⌀→", label: "absent source (novel)" },
  "absent-target": { glyph: "→⌀", label: "absent target (vanished)" },
};
const STRATA = ["surface", "structure", "intention", "trope", "invariant"];
const NARR = [
  ["celebrate", "Celebrate"], ["minimise", "Minimise"], ["better", "Better"],
  ["safety", "Safety"], ["example", "Example"],
];

const state = { items: [], view: "side-by-side", kind: "all", query: "", selected: 0 };

const $ = (id) => document.getElementById(id);

function node(tag, opts = {}, kids = []) {
  const el = document.createElement(tag);
  for (const [k, v] of Object.entries(opts)) {
    if (v == null) continue;
    if (k === "class") el.className = v;
    else if (k === "text") el.textContent = v;
    else if (k === "html") el.innerHTML = v;
    else el.setAttribute(k, v);
  }
  for (const kid of [].concat(kids)) if (kid != null) el.append(kid);
  return el;
}

function kindBadge(kind) {
  const k = KIND[kind] ?? { glyph: "?", label: kind, cls: "" };
  return node("span", { class: `badge ${k.cls}` }, [`${k.glyph} ${k.label}`]);
}

function verdictAt(strata, name) {
  const v = (strata ?? []).find((s) => s.stratum === name);
  return v ? v.holds : null;
}
// Mirrors Abi.Correspondence.isFalseFriendShape: surface holds AND intention diverges.
function isFalseFriendShape(strata) {
  return verdictAt(strata, "surface") === true && verdictAt(strata, "intention") === false;
}

function filtered() {
  const q = state.query.trim().toLowerCase();
  return state.items.filter((it) => {
    if (state.kind !== "all" && it.kind !== state.kind) return false;
    if (!q) return true;
    return [it.concept, it.from?.language, it.to?.language, it.from?.surface, it.to?.surface]
      .filter(Boolean).some((s) => String(s).toLowerCase().includes(q));
  });
}

function renderIndex() {
  const list = $("index");
  const items = filtered();
  $("indexCount").textContent = `${items.length} of ${state.items.length}`;
  list.replaceChildren();
  if (items.length === 0) {
    list.append(node("li", { class: "empty", role: "presentation", text: "No correspondences match." }));
    renderDetail(null);
    return;
  }
  if (state.selected >= items.length) state.selected = 0;
  items.forEach((it, i) => {
    const li = node("li", {
      role: "option", id: `corr-${i}`, tabindex: "-1",
      "aria-selected": String(i === state.selected),
    }, [
      node("div", { class: "concept", text: it.concept }),
      node("div", { class: "pair", text: `${it.from?.language ?? "?"} → ${it.to?.language ?? "?"}` }),
      kindBadge(it.kind),
    ]);
    li.addEventListener("click", () => { state.selected = i; syncSelection(); });
    list.append(li);
  });
  renderDetail(items[state.selected]);
  list.setAttribute("aria-activedescendant", `corr-${state.selected}`);
}

function syncSelection() {
  const items = filtered();
  document.querySelectorAll("#index li[role=option]").forEach((li, i) => {
    li.setAttribute("aria-selected", String(i === state.selected));
  });
  $("index").setAttribute("aria-activedescendant", `corr-${state.selected}`);
  const el = $(`corr-${state.selected}`);
  if (el) el.scrollIntoView({ block: "nearest" });
  renderDetail(items[state.selected]);
}

// ---- view-layers ------------------------------------------------------------

function formCard(form) {
  return node("div", { class: "form-card" }, [
    node("div", { class: "form-lang", text: form?.language ?? "?" }),
    node("pre", { class: "surface" }, [node("code", { text: form?.surface ?? "" })]),
  ]);
}

function renderForms(it) {
  const host = $("paneForms");
  host.replaceChildren();
  if (!it) { host.append(node("div", { class: "empty", text: "Select a correspondence." })); return; }
  host.append(node("h2", { class: "concept-head", text: it.concept }));
  const k = KIND[it.kind] ?? {};

  if (state.view === "raw") {
    host.append(node("pre", { class: "surface" }, [node("code", {
      text: `${it.from?.language}:  ${it.from?.surface}\n${it.to?.language}:  ${it.to?.surface}`,
    })]));
    return;
  }
  if (state.view === "focus") {
    host.append(node("div", { class: "focus-form" }, [
      node("p", { class: "pane-hint", text: `from your ${it.from?.language}: ${it.from?.surface}` }),
      formCard(it.to),
    ]));
    return;
  }
  if (state.view === "glyph") {
    host.append(node("div", { class: "glyph-view" }, [
      node("div", { class: "big", text: k.glyph ?? "?" }),
      node("div", { text: k.label ?? it.kind }),
      node("div", { class: "row" }, [
        node("div", {}, [node("div", { class: "form-lang", text: it.from?.language }), node("code", { text: it.from?.surface })]),
        node("div", { class: "cross", text: "→" }),
        node("div", {}, [node("div", { class: "form-lang", text: it.to?.language }), node("code", { text: it.to?.surface })]),
      ]),
    ]));
    return;
  }
  if (state.view === "blockly") {
    host.append(node("div", { class: "blockly" }, [
      node("div", { class: "block" }, [node("div", { class: "blang", text: it.from?.language }), node("code", { text: it.from?.surface })]),
      node("div", { class: "connector", text: `▼ ${k.glyph ?? ""} ${k.label ?? it.kind}` }),
      node("div", { class: "block" }, [node("div", { class: "blang", text: it.to?.language }), node("code", { text: it.to?.surface })]),
    ]));
    return;
  }
  // side-by-side (default)
  host.append(node("div", { class: "sxs" }, [
    formCard(it.from),
    node("div", { class: "cross" }, [document.createTextNode(k.glyph ?? "→"), node("small", { text: "becomes" })]),
    formCard(it.to),
  ]));
}

function renderClassify(it) {
  const host = $("paneClassify");
  host.replaceChildren();
  if (!it) { host.append(node("div", { class: "empty", text: "—" })); return; }
  const k = KIND[it.kind] ?? { glyph: "?", label: it.kind, pedagogy: "", blurb: "", cls: "" };

  host.append(node("div", { class: "kind-hero" }, [
    node("div", { class: `glyph ${k.cls}`, text: k.glyph }),
    node("div", {}, [
      kindBadge(it.kind),
      node("div", { class: "pedagogy", text: k.pedagogy }),
      node("div", { class: "blurb", text: k.blurb }),
    ]),
  ]));

  const res = RESIDUE[it.residue?.shape] ?? { glyph: "?", label: it.residue?.shape ?? "—" };
  host.append(node("div", { class: "section" }, [
    node("h3", { text: "Residue" }),
    node("div", { class: "residue" }, [
      node("span", { class: "glyph", text: res.glyph }),
      node("span", { class: "shape", text: res.label }),
    ]),
    it.residue?.note ? node("div", { class: "residue-note", text: it.residue.note }) : null,
  ]));

  const strataRow = node("div", { class: "strata" }, STRATA.map((s) => {
    const v = verdictAt(it.strata, s);
    const cls = v === true ? "holds" : v === false ? "diverges" : "";
    const mark = v === true ? "✓" : v === false ? "✗" : "—";
    return node("span", { class: `stratum ${cls}`, text: `${s} ${mark}` });
  }));
  const strataSection = node("div", { class: "section" }, [node("h3", { text: "Strata (levels of objects)" }), strataRow]);
  if (isFalseFriendShape(it.strata)) {
    strataSection.append(node("div", { class: "ff-flag", text: "⚠ False-friend signature: corresponds at the surface, diverges at intention." }));
  }
  host.append(strataSection);

  if (it.narrative) {
    const blocks = NARR.filter(([key]) => it.narrative[key])
      .map(([key, label]) => node("div", { class: "n" }, [node("b", { text: label }), document.createTextNode(it.narrative[key])]));
    if (blocks.length) {
      host.append(node("div", { class: "section" }, [node("h3", { text: "Narrative (no shame)" }), node("div", { class: "narrative" }, blocks)]));
    }
  }
  if (it.witness) {
    host.append(node("div", { class: "section" }, [node("h3", { text: "Witness" }), node("code", { text: it.witness })]));
  }
}

function renderDetail(it) { renderForms(it); renderClassify(it); }

// ---- events -----------------------------------------------------------------

function onKeyNav(e) {
  const items = filtered();
  if (!items.length) return;
  if (e.key === "ArrowDown" || e.key === "ArrowUp") {
    e.preventDefault();
    const d = e.key === "ArrowDown" ? 1 : -1;
    state.selected = (state.selected + d + items.length) % items.length;
    syncSelection();
  } else if (e.key === "Home") { e.preventDefault(); state.selected = 0; syncSelection(); }
  else if (e.key === "End") { e.preventDefault(); state.selected = items.length - 1; syncSelection(); }
}

async function init() {
  $("filterKind").addEventListener("change", (e) => { state.kind = e.target.value; state.selected = 0; renderIndex(); });
  $("search").addEventListener("input", (e) => { state.query = e.target.value; state.selected = 0; renderIndex(); });
  $("index").addEventListener("keydown", onKeyNav);
  document.querySelectorAll("input[name=view]").forEach((r) =>
    r.addEventListener("change", (e) => {
      state.view = e.target.value; $("viewHint").textContent = e.target.value;
      renderForms(filtered()[state.selected]);
    }));

  try {
    const res = await fetch("/api/cartridges");
    const body = await res.json();
    if (!res.ok) throw new Error(body.error || "load failed");
    state.items = (body.cartridges || []).flatMap((c) =>
      (c.transitions || []).map((t) => ({ ...t, cartridge: c.cartridge })));
    $("status").textContent = state.items.length
      ? `${state.items.length} correspondences across ${body.cartridges.length} cartridge(s)`
      : "No cartridges found.";
    renderIndex();
  } catch (err) {
    $("status").textContent = `Error: ${err.message}`;
    $("index").append(node("li", { class: "empty", text: err.message }));
  }
}

init();
