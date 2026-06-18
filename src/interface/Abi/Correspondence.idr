-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
|||
||| Abi.Correspondence — the abstraction model: Concept / Form / Transition and
||| the six graded CorrespondenceKinds. The formal heart of an engine that
||| *classifies* cross-language correspondences (it does not translate, and
||| claims no Curry-Howard fidelity). See docs/theory/CORRESPONDENCE-MODEL.adoc.

module Abi.Correspondence

import Abi.Carrier

%default total

--------------------------------------------------------------------------------
-- Strata ("levels of objects")
--------------------------------------------------------------------------------

||| The strata of meaning. Classification runs *per stratum*: a correspondence
||| can hold at one and break at another — and that divergence is the signal.
public export
data Stratum = Surface | Structure | Intention | Trope | Invariant

public export
Eq Stratum where
  (==) Surface   Surface   = True
  (==) Structure Structure = True
  (==) Intention Intention = True
  (==) Trope     Trope     = True
  (==) Invariant Invariant = True
  (==) _         _         = False

--------------------------------------------------------------------------------
-- The six CorrespondenceKinds (graded Echo fibres)
--------------------------------------------------------------------------------

||| The kind of a cross-language correspondence — a typed/graded verdict, not a
||| boolean "relates". Each kind is a grade of the Echo fibre with a pedagogy.
public export
data CorrespondenceKind : Type where
  ||| Intention + behaviour coincide; residue ~ empty. e.g. `def` -> `define`.
  Cognate : CorrespondenceKind
  ||| Surface matches, semantics diverge. e.g. BASIC `=` vs Erlang `=`.
  FalseFriend : CorrespondenceKind
  ||| Related but inverted. e.g. 0- vs 1-indexing.
  Antonym : CorrespondenceKind
  ||| Same intention, foreign mechanism, large residue. e.g. subtraction in JTV
  ||| (reversible / add-only) is `add` run backwards.
  AlienRealization : CorrespondenceKind
  ||| Forward fibre empty: nothing to map from. e.g. static types from asm+JS.
  Novel : CorrespondenceKind
  ||| Backward fibre empty: a relied-on concept is gone. e.g. `return` in ReScript.
  Vanished : CorrespondenceKind

public export
Eq CorrespondenceKind where
  (==) Cognate          Cognate          = True
  (==) FalseFriend      FalseFriend      = True
  (==) Antonym          Antonym          = True
  (==) AlienRealization AlienRealization = True
  (==) Novel            Novel            = True
  (==) Vanished         Vanished         = True
  (==) _                _                = False

||| The pedagogy prescribed by each kind.
public export
data Pedagogy = Transfer | Warn | Remap | Bridge | TeachDeNovo | ReRoute

||| Total map: every kind has exactly one pedagogy. No shame — even the traps
||| are taught, not scolded.
public export
pedagogy : CorrespondenceKind -> Pedagogy
pedagogy Cognate          = Transfer
pedagogy FalseFriend      = Warn
pedagogy Antonym          = Remap
pedagogy AlienRealization = Bridge
pedagogy Novel            = TeachDeNovo
pedagogy Vanished         = ReRoute

||| The residue shape characteristic of each kind (its Echo-fibre grade).
public export
residueShape : CorrespondenceKind -> Residue
residueShape Cognate          = None
residueShape FalseFriend      = Lossy "surface-corresponds; semantics diverge"
residueShape Antonym          = Inverted "related but inverted"
residueShape AlienRealization = Lossy "same intention; foreign mechanism"
residueShape Novel            = AbsentSource "no source anchor"
residueShape Vanished         = AbsentTarget "concept gone in the target"

--------------------------------------------------------------------------------
-- Form / Concept / Transition
--------------------------------------------------------------------------------

||| A representative of a Concept *in one language*.
public export
record Form where
  constructor MkForm
  language : String   -- e.g. "erlang", "rescript", "jtv"
  surface  : String   -- the token / snippet, e.g. "X = 5"

||| A Concept — the invariant / equivalence-class (the recurring trope) —
||| carried by an (asserted) equivalence Relation over its Forms.
public export
record Concept where
  constructor MkConcept
  name    : String         -- e.g. "name-binding"
  carrier : Relation Form  -- certifies "same idea" across Forms

||| A per-stratum verdict: does the correspondence hold at this stratum?
public export
record StratumVerdict where
  constructor MkVerdict
  stratum : Stratum
  holds   : Bool

||| A directed correspondence Form(from) -> Form(to): the classified crossing,
||| its residue, the per-stratum verdicts, and an optional `witness` anchoring
||| the claim to a proof/test — the invariant-path governance front-end, used
||| where the certifiable math pays.
public export
record Transition where
  constructor MkTransition
  concept : String
  from    : Form
  to      : Form
  kind    : CorrespondenceKind
  residue : Residue
  strata  : List StratumVerdict
  witness : Maybe String

--------------------------------------------------------------------------------
-- The false-friend signature
--------------------------------------------------------------------------------

||| Look up the verdict at a given stratum.
public export
verdictAt : Stratum -> List StratumVerdict -> Maybe Bool
verdictAt _ []        = Nothing
verdictAt s (v :: vs) = if v.stratum == s then Just v.holds else verdictAt s vs

||| The false-friend signature, made precise: *corresponds at the Surface
||| stratum yet diverges at the Intention stratum*. This is the whole reason
||| classification runs per stratum rather than as a single boolean.
public export
isFalseFriendShape : List StratumVerdict -> Bool
isFalseFriendShape vs =
  case (verdictAt Surface vs, verdictAt Intention vs) of
    (Just True, Just False) => True
    _                       => False
