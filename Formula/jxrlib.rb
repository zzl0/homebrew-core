class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://tracker.debian.org/pkg/jxrlib"
  url "http://deb.debian.org/debian/pool/main/j/jxrlib/jxrlib_1.2~git20170615.f752187.orig.tar.xz"
  sha256 "3e3c9d3752b0bbf018ed9ce01b43dcd4be866521dc2370dc9221520b5bd440d4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6dd0a252b9af046d657a6fe9e9e65092d4c756295202b74ac9ae41d896850014"
    sha256 cellar: :any,                 arm64_monterey: "5689b2bb17ccb49efc307704c0f1eb677c66cd1727605b04db013f519f90a51c"
    sha256 cellar: :any,                 arm64_big_sur:  "5fed25d3e908ae5f825c8ef875363e5f191c8ba5e932ee4675747874c33f570a"
    sha256 cellar: :any,                 ventura:        "abd82d9714ef6fae49062ca6487ccb78bc1541addd590b097206252e6cc2a17b"
    sha256 cellar: :any,                 monterey:       "a328991bf15d73c7536d31ce474cadb36a18df601ca3872115e8d8ec46bdc14e"
    sha256 cellar: :any,                 big_sur:        "a2bd992f147e427f8021e0f12a1f228887a890b23cbab7cd734c3d016fb90dae"
    sha256 cellar: :any,                 catalina:       "33134735fa04107eabadae73a3dffc8cabb8bcadf60dabe68321461366877c01"
    sha256 cellar: :any,                 mojave:         "44b1eef414a2ed12f6a647dcdb0b4d01e55445188ea7e835eaa3968f4d7ea0cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d156675a4fda8dca2c69c02a6e6b755954221d50cbff3b8bfc110238e26d7bef"
  end

  depends_on "cmake" => :build

  # Enable building with CMake. Adapted from Debian patch.
  patch do
    url "https://raw.githubusercontent.com/Gcenx/macports-wine/1b310a17497f9a49cc82789cc5afa2d22bb67c0c/graphics/jxrlib/files/0001-Add-ability-to-build-using-cmake.patch"
    sha256 "beebe13d40bc5b0ce645db26b3c8f8409952d88495bbab8bc3bebc954bdecffe"
  end

  def install
    inreplace "CMakeLists.txt", "@VERSION@", version.to_s
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bmp = "Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAQAAADDDgAAww4AAAAAAAAAAAAA////AA==".unpack1("m")
    infile  = "test.bmp"
    outfile = "test.jxr"
    File.binwrite(infile, bmp)
    system bin/"JxrEncApp", "-i", infile,  "-o", outfile
    system bin/"JxrDecApp", "-i", outfile, "-o", infile
  end
end
