//!  ```
//!  ▄· ▄▌• ▌ ▄ ·.  ▄▄▄· ▄▄▄▄▄ ▄ .▄
//! ▐█▪██▌·██ ▐███▪▐█ ▀█ •██  ██▪▐█
//! ▐█▌▐█▪▐█ ▌▐▌▐█·▄█▀▀█  ▐█.▪██▀▐█
//!  ▐█▀·.██ ██▌▐█▌▐█ ▪▐▌ ▐█▌·██▌▐▀
//!   ▀ • ▀▀  █▪▀▀▀ ▀  ▀  ▀▀▀ ▀▀▀ ·
//!
//! **YMATH** is a vector/matrix/game math SIMD library
//!
//! *Maintainer*:   github.com/aethne0 
//! *Version*:      0.0.1
//! *Date*:         2026-03-02
//! *License*:      Apache
//!
//! https://codeberg.org/yarnf/ymath
//! Please make an issue for any bugs, performance optimizations, or 
//! if you can point to a faster implementation of any math functions.
//!   ```

comptime {
   @setFloatMode(.optimized);
}

// Vectors

const vec2 = @import("vector_2.zig");
pub const Vec2  = vec2.Vec2;
pub const Vec2f64  = vec2.Vec2f64;

const vec3_a = @import("vector_3a.zig");
pub const Vec3A  = vec3_a.Vec3A;
pub const Vec3Af64  = vec3_a.Vec3Af64;

const vec4 = @import("vector_4.zig");
pub const Vec4 = vec4.Vec4;
pub const Vec4f64 = vec4.Vec4f64;

const std = @import("std");
test { 
    std.testing.refAllDecls(@This()); 
}

// -O ReleaseFast -mcpu znver5
// -O ReleaseFast -target aarch64-linux-gnu -mcpu cortex_a55
// -C opt-level=3 -C target-cpu=znver5
// -C opt-level=3 -C target-cpu=cortex_a55
