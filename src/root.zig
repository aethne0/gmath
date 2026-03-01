const std = @import("std");

/// 16-byte aligned 3-dim f32 Vector
pub const Vector3 = extern struct {
    const Self = @This();

    x: f32 align(16), // Layout wise this is a @Vector(4, f32)
    y: f32,
    z: f32,
    _pad: f32 = 0.0,

    pub fn init(x: f32, y: f32, z: f32) Self { return .{ .x = x, .y = y, .z = z }; }
    pub fn from_array(arr: [3]f32) Self { return .{ .x = arr[0], .y = arr[1], .z = arr[2] }; }
    pub fn splat(val: f32) Self { return Self.init( val, val, val ); }

    pub const ZERO = splat(0.0);
    pub const ONE  = splat(1.0);
    pub const X = init(1.0, 0.0, 0.0);
    pub const Y = init(0.0, 1.0, 0.0);
    pub const Z = init(0.0, 0.0, 1.0);

    /// Casts the vector components to a @Vector(4, f32) for SIMD
    inline fn v(self: anytype) VType(@TypeOf(self)) {
        return @ptrCast(self);
    }

    fn VType(comptime T: type) type {
        const info = @typeInfo(T).pointer;
        return if (info.is_const) *const @Vector(4, f32) else *@Vector(4, f32);
    }

    /// Element-wise
    pub fn add(a: Self, b: Self) Self {
        var res: Self = undefined;
        res.v().* = a.v().* + b.v().*;
        return res;
    }

    /// Element-wise
    pub fn sub(a: Self, b: Self) Self {
        var res: Self = undefined;
        res.v().* = a.v().* - b.v().*;
        return res;
    }

    /// Element-wise
    pub fn mul(a: Self, b: Self) Self {
        var res: Self = undefined;
        res.v().* = a.v().* * b.v().*;
        return res;
    }

    /// Element-wise
    pub fn div(a: Self, b: Self) Self {
        var res: Self = undefined;
        res.v().* = a.v().* / b.v().*;
        res._pad = 0.0;
        return res;
    }

    pub fn sum(a: Self) f32 {
        return @reduce(.Add, a.v().*);
    }

    pub fn dot(a: Self, b: Self) f32 { return a.mul(b).sum(); }

    /// Magnitude of a
    pub fn mag(a: Self) f32 { return @sqrt(a.mul(a).sum()); }

    /// Distance from a->b
    pub fn dist(a: Self, b: Self) f32 { return b.sub(a).mag(); }

    pub fn norm(a: Self) Self {
        const magnitude = a.mag();
        if (magnitude == 0.0) { return Self.ZERO; }
        return a.div(Self.splat(magnitude));
    }

    /// Rearranges components of vector. 
    /// Example: 
    /// ```
    /// var vec = Vector3.init(4, 5, 6);
    /// vec.swizzle("zxy");   // vec is now { 6, 4, 5 }
    /// vec.swizzle("yyy");   // vec is now { 4, 4, 4 }
    /// ```
    pub fn swizzle(a: Self, comptime mask: []const u8) Self {
        if (mask.len != 3) { @compileError("swizzle mask must be length 3"); } 

        comptime var order: [4]i32 = undefined;
        inline for (mask, 0..) |char, i| {
            order[i] = switch (char) {
                'x' => 0, 'y' => 1, 'z' => 2,
                else => @compileError("swizzle components must be x, y or z"),
            };
        }
        order[3] = 0;

        return @bitCast(@shuffle(f32, a.v().*, undefined, order)); 
    }

    pub fn cross(a: Self, b: Self) Self {
        const a_yzx = a.swizzle("yzx");
        const b_yzx = b.swizzle("yzx");
        const a_zxy = a.swizzle("zxy");
        const b_zxy = b.swizzle("zxy");

        return a_yzx.mul(b_zxy).sub(a_zxy.mul(b_yzx));
    }

};

