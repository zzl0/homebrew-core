class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.261.tar.gz"
  sha256 "0c67b2b76a7d6534c0f98085dbbcd4a1ac945b15b269bc81ee7dbe6cf28d53bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d648b7a47d65ea5323395d4cbcf8260bcf3beec99a67e586c3e60a6354c277f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d648b7a47d65ea5323395d4cbcf8260bcf3beec99a67e586c3e60a6354c277f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d648b7a47d65ea5323395d4cbcf8260bcf3beec99a67e586c3e60a6354c277f4"
    sha256 cellar: :any_skip_relocation, ventura:        "d648b7a47d65ea5323395d4cbcf8260bcf3beec99a67e586c3e60a6354c277f4"
    sha256 cellar: :any_skip_relocation, monterey:       "d648b7a47d65ea5323395d4cbcf8260bcf3beec99a67e586c3e60a6354c277f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d648b7a47d65ea5323395d4cbcf8260bcf3beec99a67e586c3e60a6354c277f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e0a1d787894c5b9b6de548959b3bb1835b096b0d37b9d2dc5d123571a94c2e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
