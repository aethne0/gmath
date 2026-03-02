const std = @import("std");

const rl = @cImport({ 
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});

// const V3 = @import("root.zig").Vector3;
// const M44 = @import("root.zig").Matrix44;

pub fn main(_: std.process.Init) !void {
    const screen_width = 1024;
    const screen_height = 1024;
    const virtual_width = 128;
    const virtual_height = 128;

    rl.InitWindow(screen_width, screen_height, "yee");

    const target = rl.LoadRenderTexture(virtual_width, virtual_height);
    // Ensure the texture doesn't get blurry when scaled
    rl.SetTextureFilter(target.texture, rl.TEXTURE_FILTER_POINT);

    var acc: f32 = 0;
    rl.SetTargetFPS(165);

    var triangle = [3]rl.Vector2{ 
        rl.Vector2 { .x = 16, .y = 0},
        rl.Vector2 { .x = -16, .y = -16 },
        rl.Vector2 { .x = -16, .y = 16},
    };
    const tripos = rl.Vector2 { .x = 64, .y = 64 };

    while (!rl.WindowShouldClose()) {
        acc += rl.GetFrameTime();

        {
            rl.BeginTextureMode(target);

            rl.ClearBackground(rl.BLACK);

            rl.DrawTriangle(
                rl.Vector2Rotate(triangle[0], acc).Vector2Add(tripos),
                rl.Vector2Rotate(triangle[1], acc).Vector2Add(tripos),
                rl.Vector2Rotate(triangle[2], acc).Vector2Add(tripos),
                rl.BLUE);

            const radius = 64.0 * ((1 - @cos(acc)) / 2);
            rl.DrawCircle(64, 64, radius, rl.WHITE); 

            rl.EndTextureMode();
        }

        rl.BeginDrawing();
        rl.ClearBackground(rl.RAYWHITE);
        
        const source_rect = rl.Rectangle{ 
            .x = 0, .y = 0, .width = @floatFromInt(target.texture.width), .height = @floatFromInt(-target.texture.height)
        };
        const dest_rect = rl.Rectangle{ .x = 0, .y = 0, .width = screen_width, .height = screen_height };
        const origin = rl.Vector2{ .x = 0, .y = 0 };

        rl.DrawTexturePro(target.texture, source_rect, dest_rect, origin, 0.0, rl.WHITE);

        rl.EndDrawing();
    }

    rl.CloseWindow();
}
