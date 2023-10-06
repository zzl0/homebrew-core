class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.267.tar.gz"
  sha256 "72120553215bb631275a38a5359ad812837165ab8ddd8e33597dd52c7d80d627"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29a35483e2b759f20fbc5469b20a74aaea56fedc4a0b88de57af026b2f95f4bd"
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
