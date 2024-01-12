class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r89.tar.gz"
  sha256 "3c53d2c50cfc6d0ecc7d1f326e84f11b9d3ffb4c35bc2ad73ec9c4b4f924eec5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  depends_on "pkg-config" => :build
  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Dtag=#{version}
      -Dmode=ReleaseSafe
      -Dstrip=true
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    (testpath/"zig.mod").write <<~EOS
      id: 89ujp8gq842x6mzok8feypwze138n2d96zpugw44hcq7406r
      name: zigmod
      main: src/lib.zig
      license: MIT
      description: Test zig.mod
      min_zig_version: 0.11.0
      dependencies:
        - src: git https://github.com/nektro/zig-yaml
    EOS

    (testpath/"src/lib.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
        std.log.info("Hello, world!");
      }
    EOS

    system bin/"zigmod", "fetch"
    assert_predicate testpath/"deps.zig", :exist?
    assert_predicate testpath/"zigmod.lock", :exist?

    assert_match version.to_s, shell_output("#{bin}/zigmod version")
  end
end
