class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  license "GPL-3.0-or-later"
  head "https://github.com/pdfpc/pdfpc.git", branch: "master"

  stable do
    url "https://github.com/pdfpc/pdfpc/archive/refs/tags/v4.6.0.tar.gz"
    sha256 "3b1a393f36a1b0ddc29a3d5111d8707f25fb2dd2d93b0401ff1c66fa95f50294"

    # Backport fix for Vala 0.56.7+. Remove in the next release.
    patch do
      url "https://github.com/pdfpc/pdfpc/commit/18beaecbbcc066e0d4c889b3aa3ecaa7351f7768.patch?full_index=1"
      sha256 "894a0cca9525a045f4bd28b54963bd0ad8b1752907f1ad4d8b4f7d9fdd4880c3"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "0fa98a189234582e235215997734a148ef5f4b6f96a0279e5212426eaca55a05"
    sha256 arm64_ventura:  "e35ae948acccf50487a29318c6f1d204eefc15f0545115a4f957753723b2035c"
    sha256 arm64_monterey: "5830c312af0de512390b27bcc880da91b1909195a33be690dd9f4f595469cfe8"
    sha256 sonoma:         "dd22b140aec750615ee25dbad00cf8974154ff897d4097ee270f743b929e8f13"
    sha256 ventura:        "6f042b935bb90f53a418fe117d894c95468ab193e7e10bd81756ff7907e537c0"
    sha256 monterey:       "4c8be94abad2dec957196e7cf229c99f56bd790bde5fcf284bd61487dc9384e2"
    sha256 x86_64_linux:   "581f359bbbeca6405785b33d0d9d7f3b33e59184b76f89db2f29ec79b1faaf48"
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "discount"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  on_linux do
    depends_on "webkitgtk"
  end

  def install
    # Upstream currently uses webkit2gtk-4.0 (API for GTK 3 and libsoup 2)
    # but we only provide webkit2gtk-4.1 (API for GTK 3 and libsoup 3).
    # Issue ref: https://github.com/pdfpc/pdfpc/issues/671
    inreplace "src/CMakeLists.txt", "webkit2gtk-4.0", "webkit2gtk-4.1"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DMDVIEW=#{OS.linux?}", # Needs webkitgtk
                    "-DMOVIES=ON",
                    "-DREST=OFF",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Gtk-WARNING **: 00:25:01.545: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"pdfpc", "--version"
  end
end
