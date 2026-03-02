const std = @import("std");

/// Column-major 4x4 f32 matrix
pub const Matrix44 = extern struct {
    const Self = @This();

    // Layout wise this is a `@Vector(16, f32)` or `[4]@Vector(4, f32)`
    v00: f32 align(64), v10: f32, v20: f32, v30: f32,
    v01: f32,           v11: f32, v21: f32, v31: f32,
    v02: f32,           v12: f32, v22: f32, v32: f32,
    v03: f32,           v13: f32, v23: f32, v33: f32,

    pub fn init(vals: [16]f32) Self {
        var mat: Self = undefined;
        inline for (0..16) |i| {
            mat.v_16()[i] = vals[i];
        }
        return mat;
    }

    pub fn init_aligned(vals: *align(16) [16]f32) Self {
        return @bitCast(vals);
    }

    pub fn splat(val: f32) Self {
        return init(@splat(val));
    }

    pub const IDENTITY = Self.init(
    [_]f32{
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    });

    pub const ZERO = Self.splat(0);
    pub const ONE = Self.splat(1);

    /// Cast to 4 packed 4-element f32 vectors
    inline fn v_4x4(self: anytype) 
    if (@typeInfo(@TypeOf(self)).pointer.is_const) 
        *const [4]@Vector(4, f32) 
    else 
        *[4]@Vector(4, f32)
    {
        return @ptrCast(self);
    }

    /// Cast to 16-element f32 vector
    inline fn v_16(self: anytype) 
    if (@typeInfo(@TypeOf(self)).pointer.is_const) 
        *const @Vector(16, f32) 
    else 
        *@Vector(16, f32)
    {
        return @ptrCast(self);
    }

    /// Element-wise
    pub fn add(self: Self, other: Self) Self {
        return @bitCast(self.v_16().* + other.v_16().*);
    }

    /// Element-wise
    pub fn sub(self: Self, other: Self) Self {
        return @bitCast(self.v_16().* - other.v_16().*);
    }

    /// Element-wise
    pub fn mul(self: Self, other: Self) Self {
        return @bitCast(self.v_16().* * other.v_16().*);
    }

    /// Element-wise
    pub fn div(self: Self, other: Self) Self {
        return @bitCast(self.v_16().* / other.v_16().*);
    }

    pub fn add_scalar(self: Self, scalar: f32) Self {
        return add(self, splat(scalar));
    }

    pub fn sub_scalar(self: Self, scalar: f32) Self {
        return sub(self, splat(scalar));
    }

    pub fn mul_scalar(self: Self, scalar: f32) Self {
        return mul(self, splat(scalar));
    }

    pub fn div_scalar(self: Self, scalar: f32) Self {
        return div(self, splat(scalar));
    }

    pub fn reduce_sum(self: Self) f32 {
        return @reduce(.Add, self.v_16().*);
    }

    pub fn transpose(self: Self) Self {
        return @bitCast(
            @shuffle(f32, self.v_16().*, undefined, 
                [_]i32{
                0,  4,  8, 12,
                1,  5,  9, 13,
                2,  6, 10, 14,
                3,  7, 11, 15,
            })
        );
    }

    pub fn init_from_row_major(vals: [16]f32) Self {
        return init(vals).transpose();
    }

    pub fn rotation_x(angle: f32) Self {
        var mat = IDENTITY;
        mat.v_16()[ 5] =  @cos(angle); mat.v_16()[ 6] = -@sin(angle);
        mat.v_16()[ 9] =  @sin(angle); mat.v_16()[10] =  @cos(angle);
        return mat;
    }

    pub fn rotation_y(angle: f32) Self {
        var mat = IDENTITY;
        mat.v_16()[ 0] =  @cos(angle); mat.v_16()[ 2] =  @sin(angle);
        mat.v_16()[ 8] = -@sin(angle); mat.v_16()[10] =  @cos(angle);
        return mat;
    }

    pub fn rotation_z(angle: f32) Self {
        var mat = IDENTITY;
        mat.v_16()[ 0] =  @cos(angle); mat.v_16()[ 1] = -@sin(angle);
        mat.v_16()[ 4] =  @sin(angle); mat.v_16()[ 5] =  @cos(angle);
        return mat;
    }

    pub fn matmul(self: Self, other: Self) Self {
        // ~ 17.25 cycles on ryzen 3800xt
        var result: Self = undefined;
        const a = self.v_4x4();
        const b = other.v_4x4();

        inline for (0..4) |i| {
            const col = b[i];
            
            var sum: @Vector(4, f32) = a[0] * @as(@Vector(4, f32), @splat(col[0]));
            sum = @mulAdd(@Vector(4, f32), a[1], @splat(col[1]), sum);
            sum = @mulAdd(@Vector(4, f32), a[2], @splat(col[2]), sum);
            sum = @mulAdd(@Vector(4, f32), a[3], @splat(col[3]), sum);
            
            result.v_4x4()[i] = sum;
        }
        
        return result;
    }

    /// temp debug
    pub fn print(self: Self) void {
        inline for (0..4) |i| {
            const row = self.v_4x4()[i];
            std.debug.print("{} {} {} {}\n", .{row[0], row[1], row[2], row[3]});
        }
    }
};
