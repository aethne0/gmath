const std = @import("std");

const Vec3 = @import("root.zig").Vector3_f32;

/// A fast, non-cryptographic Xoshiro128+ PRNG state
pub const FastPrng = struct {
    s: [4]u32,

    pub fn init(seed: u32) FastPrng {
        // Simple splitmix-style initialization to fill the state
        return .{ .s = .{ seed, seed +% 1, seed +% 2, seed +% 3 } };
    }

    /// Returns a random f32 in the range [0, 1)
    pub fn nextFloat(self: *FastPrng) f32 {
        // Xoshiro128+ algorithm
        const result = self.s[0] +% self.s[3];
        const t = self.s[1] << 9;

        self.s[2] ^= self.s[0];
        self.s[3] ^= self.s[1];
        self.s[1] ^= self.s[2];
        self.s[0] ^= self.s[3];

        self.s[2] ^= t;
        self.s[3] = std.math.rotl(u32, self.s[3], 11);

        // Map u32 to [0, 1) using the 24-bit mantissa of f32
        // 0x1.0p-32 is 1.0 / 2^32
        return @as(f32, @floatFromInt(result)) * 2.3283064e-10;
    }
};

pub fn main(_: std.process.Init) !void {
    //     use glam::Vec3;
    // let start = Instant::now();
    // let mut acc = 0.0;
    //     let mut xx = Vec3::from_array(aa).normalize_or_zero();
    //     let mut yy = Vec3::from_array(bb).normalize_or_zero();
    //     xx += Vec3::splat(-0.1);
    //     yy -= Vec3::splat(-0.1);
    //     let zz = Vec3::cross(xx, yy);
    //     acc += zz.length();
    // }
    // let end = Instant::now();
    // println!("{}", acc);
    // println!("-> {}", end.duration_since(start).as_secs_f32())
    
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const count = 100_000_000;
    const data = try allocator.alloc([3]f32, count);
    defer allocator.free(data);

    data[0] = .{ 1.0, 2.0, 3.0 };
    
    var rng = FastPrng.init(0);

    for (data) |*item| {
        item.* = .{ rng.nextFloat(), rng.nextFloat(), rng.nextFloat(), };
    }
    

    var acc: f32 = 0.0;
    var iter = std.mem.window([3]f32, data, 2, 2);

    var t: std.Io.Threaded = .init_single_threaded;
    const start = std.Io.Clock.real.now(t.io());

    while (iter.next()) |chunk| {
        var xx = Vec3.from_array(chunk[0]).norm();
        var yy = Vec3.from_array(chunk[1]).norm();

        xx = xx.add(Vec3.splat(0.1));
        yy = yy.sub(Vec3.splat(0.1));
        const zz = Vec3.cross(xx, yy);
        acc += zz.mag();
    }

    const end = std.Io.Clock.real.now(t.io());
    var dur: f32 = @floatFromInt(start.durationTo(end).nanoseconds);
    dur /= std.time.ns_per_s; // seconds
    std.debug.print("acc={}\n", .{acc});
    std.debug.print("{any} secs\n", .{dur});
}
