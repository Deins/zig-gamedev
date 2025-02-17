const std = @import("std");

const Options = @import("../../build.zig").Options;
const content_dir = "procedural_mesh_wgpu_content/";

pub fn build(b: *std.Build, options: Options) *std.Build.CompileStep {
    const exe = b.addExecutable(.{
        .name = "procedural_mesh_wgpu",
        .root_source_file = .{ .path = thisDir() ++ "/src/procedural_mesh_wgpu.zig" },
        .target = options.target,
        .optimize = options.optimize,
    });

    const zgui_pkg = @import("../../build.zig").zgui_pkg;
    const zmath_pkg = @import("../../build.zig").zmath_pkg;
    const zgpu_pkg = @import("../../build.zig").zgpu_pkg;
    const zglfw_pkg = @import("../../build.zig").zglfw_pkg;
    const zmesh_pkg = @import("../../build.zig").zmesh_pkg;
    const ztracy_pkg = @import("../../build.zig").ztracy_pkg;
    const znoise_pkg = @import("../../build.zig").znoise_pkg;

    zgui_pkg.link(exe);
    zgpu_pkg.link(exe);
    znoise_pkg.link(exe);
    ztracy_pkg.link(exe);
    zglfw_pkg.link(exe);
    zmesh_pkg.link(exe);
    zmath_pkg.link(exe);

    const exe_options = b.addOptions();
    exe.addOptions("build_options", exe_options);
    exe_options.addOption([]const u8, "content_dir", content_dir);

    const install_content_step = b.addInstallDirectory(.{
        .source_dir = .{ .path = thisDir() ++ "/" ++ content_dir },
        .install_dir = .{ .custom = "" },
        .install_subdir = "bin/" ++ content_dir,
    });
    exe.step.dependOn(&install_content_step.step);

    return exe;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}
