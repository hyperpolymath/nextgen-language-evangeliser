// SPDX-License-Identifier: MPL-2.0
// Copyright (c) 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
//
// FFI integration tests — verify the Zig C-ABI mirror agrees with the Idris2 ABI
// (src/interface/Abi/Correspondence.idr). Run: zig test test/integration_test.zig

const std = @import("std");
const ffi = @import("../src/main.zig");

test "pedagogy mapping matches the ABI (spot checks)" {
    try std.testing.expectEqual(ffi.Pedagogy.transfer, ffi.nle_pedagogy_of(.cognate));
    try std.testing.expectEqual(ffi.Pedagogy.warn, ffi.nle_pedagogy_of(.false_friend));
    try std.testing.expectEqual(ffi.Pedagogy.re_route, ffi.nle_pedagogy_of(.vanished));
}

test "false-friend signature matches the per-stratum rule" {
    // surface-corresponds AND intention-diverges  (e.g. BASIC = vs Erlang =)
    try std.testing.expect(ffi.nle_is_false_friend(1, 0) == 1);
    try std.testing.expect(ffi.nle_is_false_friend(1, 1) == 0);
}
