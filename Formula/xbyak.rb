class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https://github.com/herumi/xbyak"
  url "https://github.com/herumi/xbyak/archive/refs/tags/v6.73.tar.gz"
  sha256 "41f3dc7727a48c751024c92fa4da24a4a1e0ed16b7930c79d05b76960b19562d"
  license "BSD-3-Clause"
  head "https://github.com/herumi/xbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03863e0557b8f75fafda73a69047eaa5385111436316ad2afb02ccda168a326d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03863e0557b8f75fafda73a69047eaa5385111436316ad2afb02ccda168a326d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03863e0557b8f75fafda73a69047eaa5385111436316ad2afb02ccda168a326d"
    sha256 cellar: :any_skip_relocation, ventura:        "03863e0557b8f75fafda73a69047eaa5385111436316ad2afb02ccda168a326d"
    sha256 cellar: :any_skip_relocation, monterey:       "03863e0557b8f75fafda73a69047eaa5385111436316ad2afb02ccda168a326d"
    sha256 cellar: :any_skip_relocation, big_sur:        "03863e0557b8f75fafda73a69047eaa5385111436316ad2afb02ccda168a326d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6983a30eb6cf8ca221aa10db6cb96ace697ea0ada3949cddf9407f93ecdb02e8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <xbyak/xbyak_util.h>

      int main() {
        Xbyak::util::Cpu cpu;
        cpu.has(Xbyak::util::Cpu::tSSE42);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-c", "-I#{include}"
  end
end
