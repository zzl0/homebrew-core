class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v6.338.2/libplacebo-v6.338.2.tar.bz2"
    sha256 "1c02d21720f972cae02111a1286337e9d0e70d623b311a1e4245bac5ce987f28"

    resource "fast_float" do
      url "https://github.com/fastfloat/fast_float/archive/refs/tags/v6.0.0.tar.gz"
      sha256 "7e98671ef4cc7ed7f44b3b13f80156c8d2d9244fac55deace28bd05b0a2c7c8e"
    end

    resource "glad2" do
      url "https://files.pythonhosted.org/packages/8b/b3/191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2b/glad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja2" do
      url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
      sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "577a51429582caf30d0d24247b1b626393bce79e73a0a49794d2dba8da7c90d6"
    sha256 cellar: :any, arm64_ventura:  "2c55ed71dbbfba03e4c640f9983fe2f1efaf67277a7fc763251ed1c3c6a255e9"
    sha256 cellar: :any, arm64_monterey: "ca90a437a9336825fe6a6e871d73d5281a34b4f7843a5159747f2d2352c5e7ff"
    sha256 cellar: :any, sonoma:         "2c77c0e0ada6e5122f9ad19695e6ee58fa1e00047adb3e50a4f36c64fe8399ff"
    sha256 cellar: :any, ventura:        "97dd7cf5f6e6e1e1f50204a0daa3ccf8786c7761d442d58cc1194e6edbacefb1"
    sha256 cellar: :any, monterey:       "f947b0e79a977b544e1ecc38c7aa2af8ffa9f4011299c7a0bdc48fc863d83781"
    sha256               x86_64_linux:   "e7fa0f3a2f564af33caf681ec0e871d75664191f8fa7f9e28641e7d1e9291897"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-headers" => :build

  depends_on "little-cms2"
  depends_on "python-markupsafe"
  depends_on "shaderc"
  depends_on "vulkan-loader"

  def install
    resources.each do |r|
      # Override resource name to use expected directory name
      dir_name = case r.name
      when "glad2", "jinja2"
        r.name.sub(/\d+$/, "")
      else
        r.name
      end

      r.stage(Pathname("3rdparty")/dir_name)
    end

    system "meson", "setup", "build",
                    "-Dvulkan-registry=#{Formula["vulkan-headers"].share}/vulkan/registry/vk.xml",
                    "-Dshaderc=enabled", "-Dvulkan=enabled", "-Dlcms=enabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libplacebo/config.h>
      #include <stdlib.h>
      int main() {
        return (pl_version() != NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lplacebo"
    system "./test"
  end
end
