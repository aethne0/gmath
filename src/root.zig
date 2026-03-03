//!  ▄· ▄▌ ▄▄▄· ▄▄▄   ▐ ▄  ▌ ▐·▄▄▄ . ▄▄· 
//! ▐█▪██▌▐█ ▀█ ▀▄ █·•█▌▐█▪█·█▌▀▄.▀·▐█ ▌▪
//! ▐█▌▐█▪▄█▀▀█ ▐▀▀▄ ▐█▐▐▌▐█▐█•▐▀▀▪▄██ ▄▄
//!  ▐█▀·.▐█ ▪▐▌▐█•█▌██▐█▌ ███ ▐█▄▄▌▐███▌
//!   ▀ •  ▀  ▀ .▀  ▀▀▀ █▪. ▀   ▀▀▀ ·▀▀▀ 
//!
//! **YARNVEC** is a vector/matrix/game math SIMD library
//!
//! *Maintainer*:   github.com/aethne0 
//! *Version*:      0.0.1
//! *Date*:         2026-03-02
//! *License*:      Apache | MIT
//!
//! https://github.com/aethne0/YARNVEC
//! Please make an issue for any bugs, performance optimizations, or 
//! if you can point to a faster implementation of any math functions.

const std = @import("std");

pub const vec = @import("vector_aligned.zig");
pub const mat = @import("matrix.zig");

test { std.testing.refAllDecls(@This()); }

