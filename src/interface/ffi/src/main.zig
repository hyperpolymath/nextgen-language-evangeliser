// SPDX-License-Identifier: MPL-2.0
// Copyright (c) 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
//
// Nextgen Languages Evangeliser — FFI seam (Zig).
//
// The C-ABI mirror of the Idris2 ABI in src/interface/Abi/ (Abi.Carrier +
// Abi.Correspondence). Idris2 owns the proofs; Zig owns the C boundary. The two
// MUST agree: the enums and the pedagogy / false-friend semantics here mirror
// Abi.Correspondence exactly. Verify with: zig test src/main.zig
//
// Original MPL-2.0 — no AGPL/echo-types linkage (see ../Abi/README.adoc).

const std = @import("std");

//==============================================================================
// Enums — must match Abi.Correspondence
//==============================================================================

/// The six graded kinds of cross-language correspondence.
pub const CorrespondenceKind = enum(c_int) {
    cognate = 0,
    false_friend = 1,
    antonym = 2,
    alien_realization = 3,
    novel = 4,
    vanished = 5,
};

/// The pedagogy prescribed by each kind.
pub const Pedagogy = enum(c_int) {
    transfer = 0,
    warn = 1,
    remap = 2,
    bridge = 3,
    teach_de_novo = 4,
    re_route = 5,
};

/// Strata of meaning ("levels of objects").
pub const Stratum = enum(c_int) {
    surface = 0,
    structure = 1,
    intention = 2,
    trope = 3,
    invariant = 4,
};

//==============================================================================
// Total maps — mirror Idris2 `pedagogy` and `residueShape`
//==============================================================================

/// pedagogy : CorrespondenceKind -> Pedagogy  (total)
pub export fn nle_pedagogy_of(kind: CorrespondenceKind) Pedagogy {
    return switch (kind) {
        .cognate => .transfer,
        .false_friend => .warn,
        .antonym => .remap,
        .alien_realization => .bridge,
        .novel => .teach_de_novo,
        .vanished => .re_route,
    };
}

/// Is the kind's residue a true isomorphism (None)? Only Cognate. Returns 1/0.
pub export fn nle_residue_is_iso(kind: CorrespondenceKind) u32 {
    return if (kind == .cognate) 1 else 0;
}

/// A stable, lowercase name for a kind (static storage; do not free).
pub export fn nle_kind_name(kind: CorrespondenceKind) [*:0]const u8 {
    return switch (kind) {
        .cognate => "cognate",
        .false_friend => "false-friend",
        .antonym => "antonym",
        .alien_realization => "alien-realization",
        .novel => "novel",
        .vanished => "vanished",
    };
}

//==============================================================================
// The false-friend signature — mirrors Abi.Correspondence.isFalseFriendShape
//==============================================================================

/// Corresponds at Surface AND diverges at Intention. Inputs are bool-as-u32
/// (non-zero = holds). Returns 1 if the crossing is a false friend.
pub export fn nle_is_false_friend(surface_holds: u32, intention_holds: u32) u32 {
    return if (surface_holds != 0 and intention_holds == 0) 1 else 0;
}

//==============================================================================
// Version
//==============================================================================

pub export fn nle_version() [*:0]const u8 {
    return "0.1.0";
}

//==============================================================================
// Tests — mirror the Idris2 semantics
//==============================================================================

test "pedagogy mapping is total and matches the ABI" {
    try std.testing.expectEqual(Pedagogy.transfer, nle_pedagogy_of(.cognate));
    try std.testing.expectEqual(Pedagogy.warn, nle_pedagogy_of(.false_friend));
    try std.testing.expectEqual(Pedagogy.remap, nle_pedagogy_of(.antonym));
    try std.testing.expectEqual(Pedagogy.bridge, nle_pedagogy_of(.alien_realization));
    try std.testing.expectEqual(Pedagogy.teach_de_novo, nle_pedagogy_of(.novel));
    try std.testing.expectEqual(Pedagogy.re_route, nle_pedagogy_of(.vanished));
}

test "only cognate is a true isomorphism" {
    try std.testing.expect(nle_residue_is_iso(.cognate) == 1);
    try std.testing.expect(nle_residue_is_iso(.false_friend) == 0);
    try std.testing.expect(nle_residue_is_iso(.vanished) == 0);
}

test "false-friend signature: surface holds AND intention diverges" {
    try std.testing.expect(nle_is_false_friend(1, 0) == 1); // BASIC = vs Erlang =
    try std.testing.expect(nle_is_false_friend(1, 1) == 0);
    try std.testing.expect(nle_is_false_friend(0, 0) == 0);
    try std.testing.expect(nle_is_false_friend(0, 1) == 0);
}

test "kind names are stable" {
    try std.testing.expectEqualStrings("false-friend", std.mem.span(nle_kind_name(.false_friend)));
}

test "version is non-empty" {
    try std.testing.expect(std.mem.span(nle_version()).len > 0);
}
