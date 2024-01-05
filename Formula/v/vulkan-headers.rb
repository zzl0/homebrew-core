class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.3.275.tar.gz"
  sha256 "7161da645dbd33fd4ea61eec08e0d77389a640010acbf4afc00234f84df9b314"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca9dd030127be297301ded7cdf814b9039a7d48f56055de11e04ca745965c736"
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
