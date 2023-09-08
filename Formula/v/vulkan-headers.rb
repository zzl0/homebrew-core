class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.264.tar.gz"
  sha256 "e5d47599b971d8fe223b034019f7da736a97cdd6c3899b83a5d8873ff23e0e62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65015c5fcf9c3c2833482201a4262d60476f6a8f1949276e24b2c12e02c7aa5b"
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
