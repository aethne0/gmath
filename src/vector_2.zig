const std = @import("std");
const vector_common = @import("vector_common.zig");

pub fn Vector2(comptime FType: type) type {
    if (FType != f32 and FType != f64) @compileError("fType must be f32 | f64");

    return extern struct {
        const Self = @This();
        const shared = vector_common.VectorAlignedCommon(FType, 2, Self);

        x:      FType align(@sizeOf(FType) * 2),
        y:      FType,

        /// Initialize struct with values
        /// Example: `const some_vec = Vec3A.init(.{1, 2, 3});`
        pub fn init(x: FType, y: FType) Self {
            return .{ .x = x, .y = y };
        }

        const as_vec = shared.as_vec;

        pub const splat = shared.splat;

        /// X-direction unit vector
        pub const X         = init(1, 0);
        /// Y-direction unit vector
        pub const Y         = init(0, 1);
        /// negative X-direction unit vector
        pub const NEG_X     = init(-1, 0);
        /// negative Y-direction unit vector
        pub const NEG_Y     = init(0, -1);
        /// array of all positive unit vectors
        pub const AXES      = [_]Self{ X, Y };

        pub const ZERO = shared.ZERO;
        pub const ONE = shared.ONE;
        pub const NEG_ONE = shared.NEG_ONE;
        pub const MIN = shared.MIN;
        pub const MAX = shared.MAX;
        pub const NAN = shared.NAN;
        pub const INF = shared.INF;
        pub const NEG_INF = shared.NEG_INF;

        pub const add = shared.add;
        pub const sub = shared.sub;
        pub const mul = shared.mul;
        pub const div = shared.div;
        pub const add_scalar  = shared.add_scalar;
        pub const sub_scalar  = shared.sub_scalar;
        pub const mul_scalar  = shared.mul_scalar;
        pub const div_scalar = shared.div_scalar;
        pub const mul_add = shared.mul_add;
        pub const neg  = shared.neg;
        pub const ceil  = shared.ceil;
        pub const round  = shared.round;
        pub const floor  = shared.floor;
        pub const sin  = shared.sin;
        pub const cos  = shared.cos;
        pub const ln  = shared.ln;
        pub const log2  = shared.log2;
        pub const exp  = shared.exp;
        pub const exp2  = shared.exp2;
        pub const recip  = shared.recip;
        pub const sqrt  = shared.sqrt;
        pub const recip_sqrt_fast  = shared.recip_sqrt_fast;
        pub const abs  = shared.abs;
        pub const min  = shared.min;
        pub const max  = shared.max;
        pub const saturate = shared.saturate;
        pub const length_squared = shared.length_squared;
        pub const length = shared.length;
        pub const length_recip = shared.length_recip;
        pub const clamp_length_max = shared.clamp_length_max;
        pub const clamp_length_min = shared.clamp_length_min;
        pub const clamp_length = shared.clamp_length;
        pub const set_length = shared.set_length;
        pub const distance_squared = shared.distance_squared;
        pub const distance = shared.distance;
        pub const distance_recip = shared.distance_recip;
        pub const normalize = shared.normalize;
        pub const normalize_and_length = shared.normalize_and_length;
        pub const normalize_or_zero = shared.normalize_or_zero;
        pub const is_normalized = shared.is_normalized;
        pub const lerp = shared.lerp;
        pub const midpoint = shared.midpoint;
        pub const swizzle = shared.swizzle;

        pub const product  = shared.product;
        pub const min_element  = shared.min_element;
        pub const max_element  = shared.max_element;
        pub const sum  = shared.sum;
        pub const eq = shared.eq;
        pub const clamp_by_scalars = shared.clamp_by_scalars;
        pub const clamp = shared.clamp;

    };
}


test {
    const Vec2  = Vector2(f32);

    const t = std.testing;

    const some = Vec2.init(1, 2);
    try t.expectEqual(1, some.x);
    try t.expectEqual(2, some.y);

    // todo tests
}

