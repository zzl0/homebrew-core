class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2023.12.14.tar.gz"
  sha256 "407d5e109a70ec1b6cd3380ce357c21e3d3651a91caae6d0d8e1719c69a1791d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de984134741d637abd45f816b195d03e771e74e38d9cca8e70e65e54d03afaac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8bc77ea328329b357d2782a4a7f540bf6cfc8b63d308652b1c0ca0c06d0ce29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8bc77ea328329b357d2782a4a7f540bf6cfc8b63d308652b1c0ca0c06d0ce29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8bc77ea328329b357d2782a4a7f540bf6cfc8b63d308652b1c0ca0c06d0ce29"
    sha256 cellar: :any_skip_relocation, sonoma:         "de984134741d637abd45f816b195d03e771e74e38d9cca8e70e65e54d03afaac"
    sha256 cellar: :any_skip_relocation, ventura:        "d8bc77ea328329b357d2782a4a7f540bf6cfc8b63d308652b1c0ca0c06d0ce29"
    sha256 cellar: :any_skip_relocation, monterey:       "d8bc77ea328329b357d2782a4a7f540bf6cfc8b63d308652b1c0ca0c06d0ce29"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8bc77ea328329b357d2782a4a7f540bf6cfc8b63d308652b1c0ca0c06d0ce29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ebc91efd80fdd10af86d228a281056bd00cb709739b0269db06c77002ea6e3"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <CL/opencl.h>

      int main(void) {
        printf("opencl.h standalone test PASSED.");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "opencl.h standalone test PASSED.", shell_output("./test")
  end
end
