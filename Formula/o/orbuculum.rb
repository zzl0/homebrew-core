class Orbuculum < Formula
  desc "Arm Cortex-M SWO/SWV Demux and Postprocess"
  homepage "https://github.com/orbcode/orbuculum"
  url "https://github.com/orbcode/orbuculum/archive/refs/tags/V2.1.0.tar.gz"
  sha256 "ccdd86130094001a0ab61e5501a6636e12c82b0b44690795a2911c65c5618c46"
  license "BSD-3-Clause"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "libusb"
  depends_on "sdl2"
  depends_on "zeromq"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "libelf"
  end
  on_linux do
    depends_on "elfutils"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build", "--tags", "devel,runtime"
  end

  # The tools do not report their version correctly when installed from a
  # GitHub release rather than from Git directly for versions <= 2.1.0.
  # This has now been rectified, and the versions can be tested for future
  # releases.
  test do
    assert_match "orbuculum version undefined", shell_output("#{bin}/orbuculum --version 2>&1", 255)
    assert_match "orbcat version undefined", shell_output("#{bin}/orbcat --version 2>&1", 255)
    assert_match "orbdump version undefined", shell_output("#{bin}/orbdump --version 2>&1", 255)
    assert_match "orbfifo version undefined", shell_output("#{bin}/orbfifo --version 2>&1", 255)
    assert_match "orblcd version undefined", shell_output("#{bin}/orblcd --version 2>&1", 255)
    assert_match "Elf File not specified", shell_output("#{bin}/orbmortem 2>&1")
    assert_match "This utility is in development. Use at your own risk!!\nElf File not specified",
                 shell_output("#{bin}/orbprofile 2>&1", 254).sub("\r", "")
    assert_match "Elf File not specified", shell_output("#{bin}/orbstat 2>&1", 254)
    assert_match "Elf File not specified", shell_output("#{bin}/orbtop 2>&1", 247)
    assert_match "No devices found", shell_output("#{bin}/orbtrace 2>&1")
    assert_match "orbcat version undefined", shell_output("#{bin}/orbzmq --version 2>&1", 255)
  end
end
