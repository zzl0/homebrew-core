class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.78/gobject-introspection-1.78.0.tar.xz"
  sha256 "84f5bd2038bd52abbce74a639832c5b46a2d17e9c5a8ae14f9788e8516c04166"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_ventura:  "0893c5b8d8dc89d1649c6d72c2d2a29fbe9412a5348a5e1fb28ebc284d46332e"
    sha256 arm64_monterey: "582383ac2d0f617df8638783bc39223626575e33e8248a5241ec115f576797ca"
    sha256 arm64_big_sur:  "89eaa90a0ac005b0b0d320b301be097029def2049b44e26361b7bacc2c03dd39"
    sha256 ventura:        "3382ba757d765b37a4cc62ea56a1954df7e889de9eb876017040afc86ded8fd4"
    sha256 monterey:       "5e4879812fefd3b8edc8f0ce6c99e876c1c849537510df29305acf1ac9c2ae11"
    sha256 big_sur:        "17f6ce7c80d81bcb4a125fd2248a89489c71b9080935873c0a7b261facac4337"
    sha256 x86_64_linux:   "0ba66387b38379e17cf178709bba85e055385192c8596a117ea6ff97fc997574"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-311-darwin.so`, so needs a specific version.
  depends_on "python@3.11"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def python3
    which("python3.11")
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{python3}",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    resource "homebrew-tutorial" do
      url "https://gist.github.com/tdsmith/7a0023656ccfe309337a.git",
          revision: "499ac89f8a9ad17d250e907f74912159ea216416"
    end

    resource("homebrew-tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
