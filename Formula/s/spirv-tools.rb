class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.3.268.0.tar.gz"
  sha256 "4c19fdcffb5fe8ef8dc93d7a65ae78b64edc7a5688893ee381c57f70be77deaf"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d22d8c5984c120ada35dcec596e672e5da421c718b964195db049f9ee664efa1"
    sha256 cellar: :any,                 arm64_ventura:  "cd86ec4dadaf9a5df724b5e8e2d0b3434e9dece5f1d0f693171e2b3b49614e31"
    sha256 cellar: :any,                 arm64_monterey: "0637ae77abc11f9ba1677119426ce011fb2e5f6580abcda1d6a6c44503127a69"
    sha256 cellar: :any,                 arm64_big_sur:  "ee408e7ebba7faf63f468dbc17addff81d36a1d056abdacb070c5cf542b178b3"
    sha256 cellar: :any,                 sonoma:         "3320c6c6de9b06ab9b5d6737d25d9b8895f8e4086a95d7bbcccf7e9b3e2ff856"
    sha256 cellar: :any,                 ventura:        "4bc22b444e909a223e10dd78a4769dc610f5d81bc115d3baf4f047c11af9b5c6"
    sha256 cellar: :any,                 monterey:       "058ed9c4f4104887ae3a57458ee1d4e5b13f82b7303f114b4db5920aa25389d8"
    sha256 cellar: :any,                 big_sur:        "b212c0450234482cbf842614c8c8c82cbc2fa00eb6e4f63aae88aeeb47e05841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0f52bb57518a8cd11a581164b724b2585c0b63753aabe2263027c1ab1bde5c"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "1c6bb2743599e6eb6f37b2969acc0aef812e32e3"
  end

  def install
    (buildpath/"external/spirv-headers").install resource("spirv-headers")

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
