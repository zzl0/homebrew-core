class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "ac0941ce4a0aae76901133c0d65975a17632734534668ce2871aacb0d99a036c"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8dc0287eeb379ffda4eb6ad17fcfe14f6ed1f8a20511229e54174e8e9b29ff08"
    sha256 cellar: :any,                 arm64_monterey: "93559a68c27f0cb96078b8eccf8889502982d92122112c8e196d385d3df4878a"
    sha256 cellar: :any,                 arm64_big_sur:  "264acd4a351621ae3cf17495120b5e5d7b7e0bfa1b94d60faba2462a8024ab9d"
    sha256 cellar: :any,                 ventura:        "229daac40adcfe4889fb384683b3bfd3d4626012a0399d56e47a5aa23fe1fdd1"
    sha256 cellar: :any,                 monterey:       "7943fe7ca15199580673d64743c29616d0949465d1c8f25055f2c5972f32c329"
    sha256 cellar: :any,                 big_sur:        "cdcac9acdbe74fdbaa29871f9a8949003d0650829c97928736b0f9f1e5a96824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb93bb2bdbe058e1570928d9774ae12bb9c8a8ac951d2fbd3c7dfb60843528e5"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.11" => :build
  depends_on "llvm@16"

  on_linux do
    depends_on "tbb"
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Force cmake to use our compiler shims instead of bypassing them.
    inreplace "CMakeLists.txt", "set(CMAKE_C_COMPILER \"clang\")", "set(CMAKE_C_COMPILER \"#{ENV.cc}\")"
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_COMPILER \"clang++\")", "set(CMAKE_CXX_COMPILER \"#{ENV.cxx}\")"

    # Disable building of i686 target on Linux, which we do not support.
    inreplace "cmake/GenerateBuiltins.cmake", "set(target_arch \"i686\")", "return()" unless OS.mac?

    args = %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR=#{llvm.opt_bin}
    ]
    # We can target ARM for free on macOS, so let's use the upstream default there.
    args << "-DARM_ENABLED=OFF" if OS.linux? && Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"simple.ispc").write <<~EOS
      export void simple(uniform float vin[], uniform float vout[], uniform int count) {
        foreach (index = 0 ... count) {
          float v = vin[index];
          if (v < 3.)
            v = v * v;
          else
            v = sqrt(v);
          vout[index] = v;
        }
      }
    EOS

    if Hardware::CPU.arm?
      arch = "aarch64"
      target = "neon"
    else
      arch = "x86-64"
      target = "sse2"
    end
    system bin/"ispc", "--arch=#{arch}", "--target=#{target}", testpath/"simple.ispc",
                       "-o", "simple_ispc.o", "-h", "simple_ispc.h"

    (testpath/"simple.cpp").write <<~EOS
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end
