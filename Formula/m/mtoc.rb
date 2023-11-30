class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-1009.2.tar.gz"
  sha256 "da3b7d3a9069e9c0138416e3ec56dbb7dd165b73d108d3cee6397031d9582255"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fbf003deb50e3d981f6185f47e9d26cf03ecab59bcec5e6976dd0d9a5e1f75e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d75f24e8a8dbf876aa37fddd44139c5177b08348210ef3acacedb5ba8e1dc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebb0ffb0ba60ca6d02f0df9919427bf8a2579632e585a2a6ae851c5fbe858cc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "935bfd119379ec4d223830db858a2b2279152709a6e78eba895af5859110d22f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cec74d24e4f0e02404ba18a486fa61a9c5cfd060e07ec131c241681ce9e25f32"
    sha256 cellar: :any_skip_relocation, ventura:        "bd70c47294b5c9bee72d0e7d0c2d1b8779eefd367a01ce13409cbb1191919798"
    sha256 cellar: :any_skip_relocation, monterey:       "fd72c247a0ea992a4ab1a645e3a51007331a1bd15fc693e93fc1bd0267f38273"
    sha256 cellar: :any_skip_relocation, big_sur:        "605abc57733add4e0643d6ffa0186df37e1b4adb5461b9fcdd92d1bfb688f649"
    sha256 cellar: :any_skip_relocation, catalina:       "2f60b3731066cf662f3d8e9451ce0f94954980100780c9e79b6e8ea066ad8def"
    sha256 cellar: :any_skip_relocation, mojave:         "c9cba74c5669816e90ae2fa9110be8c9b6b9d1a90ec7d1f246687a3f512e08ab"
    sha256 cellar: :any_skip_relocation, high_sierra:    "62587e723f38c2a51d3a951dca42df10b9aa1ac67c88d8e286b27e6957edd985"
  end

  depends_on "llvm" => :build
  depends_on :macos
  conflicts_with "ocmtoc", because: "both install `mtoc` binaries"

  patch do
    url "https://raw.githubusercontent.com/acidanthera/ocbuild/d3e57820ce85bc2ed4ce20cc25819e763c17c114/patches/mtoc-permissions.patch"
    sha256 "0d20ee119368e30913936dfee51055a1055b96dde835f277099cb7bcd4a34daf"
  end

  # Rearrange #include's to avoid macros defining function argument names in
  # LLVM's headers.
  patch :DATA

  def install
    # error: DT_TOOLCHAIN_DIR cannot be used to evaluate HEADER_SEARCH_PATHS, use TOOLCHAIN_DIR instead
    inreplace "xcode/libstuff.xcconfig", "${DT_TOOLCHAIN_DIR}/usr/local/include",
                                         Formula["llvm"].opt_include

    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "cctools.xcodeproj",
               "-scheme", "mtoc",
               "-configuration", "Release",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "CONFIGURATION_BUILD_DIR=build/Release",
               "HEADER_SEARCH_PATHS=#{Formula["llvm"].opt_include} $(HEADER_SEARCH_PATHS)"
    bin.install "build/Release/mtoc"
    man1.install "man/mtoc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      __attribute__((naked)) int start() {}
    EOS

    args = %W[
      -nostdlib
      -Wl,-preload
      -Wl,-e,_start
      -seg1addr 0x1000
      -o #{testpath}/test
      #{testpath}/test.c
    ]
    system ENV.cc, *args
    system "#{bin}/mtoc", "#{testpath}/test", "#{testpath}/test.pe"
  end
end

__END__
diff --git a/libstuff/lto.c b/libstuff/lto.c
index ee9fc32..29b986c 100644
--- a/libstuff/lto.c
+++ b/libstuff/lto.c
@@ -6,8 +6,8 @@
 #include <sys/file.h>
 #include <dlfcn.h>
 #include <llvm-c/lto.h>
-#include "stuff/ofile.h"
 #include "stuff/llvm.h"
+#include "stuff/ofile.h"
 #include "stuff/lto.h"
 #include "stuff/allocate.h"
 #include "stuff/errors.h"
