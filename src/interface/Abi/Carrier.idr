-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
|||
||| Abi.Carrier — the formal carrier of a cross-language equivalence *claim*.
|||
||| This is ORIGINAL MPL-2.0 code. It is conceptually grounded in — but does
||| not import — two estate libraries, to keep the licence clean:
|||
|||   * the Dyadic `Relation` (reflexive/symmetric/transitive) from
|||     hyperpolymath/proven-tests-and-benches  (AGPL-3.0-or-later, son-shared)
|||   * the Echo loss-with-residue fibre `Echo f y := Sigma (x : A), f x = y`
|||     from hyperpolymath/echo-types            (Agda)
|||
||| Importing the AGPL library into this MPL-2.0 repo would relicense it by
||| linkage; the shapes are re-expressed here as fresh MPL-2.0 source instead.

module Abi.Carrier

%default total

||| A binary relation over `a` together with its (asserted) algebraic
||| properties. The carrier of an equivalence *claim*: a Concept is "the same
||| idea" across Forms exactly when this relation is an equivalence.
public export
record Relation (a : Type) where
  constructor MkRelation
  name       : String
  relates    : a -> a -> Bool
  reflexive  : Bool
  symmetric  : Bool
  transitive : Bool

||| Equivalence = reflexive AND symmetric AND transitive.
public export
isEquivalence : Relation a -> Bool
isEquivalence (MkRelation _ _ r s t) = r && s && t

||| The residue of a crossing A -> B: *what is lost, added, or inverted*.
||| These are the grades of the Echo fibre, from empty (true iso) through
||| inverted / lossy to empty-in-either-direction.
public export
data Residue : Type where
  ||| True isomorphism — nothing lost (the fibre is inhabited and unique).
  None         : Residue
  ||| The crossing is a flip (e.g. 0- vs 1-indexing). Carries a note.
  Inverted     : String -> Residue
  ||| One-way loss / added machinery (a retraction): same intention, foreign
  ||| mechanism. Carries a note of the machinery.
  Lossy        : String -> Residue
  ||| Forward fibre empty: the target concept has no source anchor. (Novel.)
  AbsentSource : String -> Residue
  ||| Backward fibre empty: the source concept has vanished in the target.
  AbsentTarget : String -> Residue

||| Is this crossing a true isomorphism (no residue)?
public export
isIso : Residue -> Bool
isIso None = True
isIso _    = False
