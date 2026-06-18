// SPDX-License-Identifier: MPL-2.0
// Copyright (c) 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
//
// FFI build configuration (Zig 0.15.2+). Minimal scaffolding: the FFI seam
// mirrors the Idris2 ABI in src/interface/Abi/. Run the unit tests directly:
//   zig test src/main.zig
//   zig test test/integration_test.zig

const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.standardTargetOptions(.{});
    _ = b.standardOptimizeOption(.{});
    // Tests run via `zig test src/main.zig`. Expand to addStaticLibrary /
    // addTest steps when the AffineScript host binding consumes this seam.
}
