const std = @import("std");

pub fn build(_: *std.Build) void {}

pub fn addLibraryPathsTo(compile_step: *std.Build.Step.Compile) void {
    const target = compile_step.rootModuleTarget();

    switch (target.os.tag) {
        .windows => {
            if (target.cpu.arch.isX86()) {
                if (target.abi.isGnu() or target.abi.isMusl()) {
                    compile_step.addLibraryPath(.{ .cwd_relative = "windows/lib/x86_64-windows-gnu" });
                }
            }
        },
        .macos => {
            compile_step.addLibraryPath(.{ .cwd_relative = "macos12/usr/lib" });
            compile_step.addFrameworkPath(.{ .cwd_relative = "macos12/System/Library/Frameworks" });
        },
        .linux => {
            if (target.cpu.arch.isX86()) {
                compile_step.addLibraryPath(.{ .cwd_relative = "linux/lib/x86_64-linux-gnu" });
            } else if (target.cpu.arch == .aarch64) {
                compile_step.addLibraryPath(.{ .cwd_relative = "linux/lib/aarch64-linux-gnu" });
            }
        },
        else => {},
    }
}
