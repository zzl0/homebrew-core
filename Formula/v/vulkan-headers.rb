class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.262.tar.gz"
  sha256 "317e467a5fb2eaa6a18b984ec70fdbfaccd93595a3e6f4bcceca7d3fab280505"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "673006a0c21c721b0ba7557a41661fa55b8e89d21ab412aabf39a69c11c2aaaa"
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
