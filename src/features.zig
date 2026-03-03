const std = @import("std");
const builtin = @import("builtin");

pub const X86_SSE = builtin.cpu.features.isEnabled(@intFromEnum(std.Target.x86.Feature.sse));
pub const X86_AVX = builtin.cpu.features.isEnabled(@intFromEnum(std.Target.x86.Feature.avx));
pub const AARCH64_NEON = builtin.cpu.features.isEnabled(@intFromEnum(std.Target.aarch64.Feature.neon));

pub const x86 = @cImport(@cInclude("immintrin.h"));

