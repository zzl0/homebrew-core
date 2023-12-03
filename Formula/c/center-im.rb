class CenterIm < Formula
  desc "Text-mode multi-protocol instant messaging client"
  homepage "https://github.com/petrpavlu/centerim5"
  url "https://github.com/petrpavlu/centerim5/releases/download/v5.0.1/centerim5-5.0.1.tar.gz"
  sha256 "b80b999e0174b81206255556cf00de6548ea29fa6f3ea9deb1f9ab59d8318313"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d75f8b87c2bcd20519e83e938faccbc543fd1501b7c606d6ebb629a725ed9d63"
    sha256 arm64_ventura:  "06ea3b5f68d56428232fe118e9acd8991bc874339e4a871cc353090f8fd35279"
    sha256 arm64_monterey: "1a7055bb3ef5921a9a7879b1d5a6b1c1e208e10e74775118aa266e60fdc1b0b4"
    sha256 arm64_big_sur:  "da6277844c78cbc85d849be46094d4a67e3ab57cc6bf41d2cb5332a36db0ca7c"
    sha256 sonoma:         "6e36cf572c5c13d94fbbc516f9ae591c03103fabfbbf4c3cb2587cfbd6021909"
    sha256 ventura:        "eaac6faf7415659261e938587b564ee5190fe7df96ef1a7b9cd7e946a21a5c63"
    sha256 monterey:       "5647b6358b2c0c1b95fef613b5dd9818a584b2e127bbd85ee1dd329b698c4ebc"
    sha256 big_sur:        "d8b97d13db945bc0a2fe883bfa8394c70496f1cdd4bc8624c3fdf43dab824ccd"
    sha256 x86_64_linux:   "da7275cf3357b6ba3b363fc938f80e4639ebf5e0732b0f5705a1c467093d5567"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++@2"
  depends_on "pidgin" # for libpurple

  uses_from_macos "ncurses", since: :sonoma

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work around build error on macOS due to `version` file confusing system header.
    # Also allow CMake to correctly set the version number inside binary.
    # Issue ref: https://github.com/petrpavlu/centerim5/issues/1
    mv "version", ".tarball-version"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/centerim5 --version")

    # FIXME: Unable to run TUI test in Linux CI.
    # Error is "Placing the terminal into raw mode failed."
    return if ENV["HOMEBREW_GITHUB_ACTIONS"] && OS.linux?

    ENV["TERM"] = "xterm"
    File.open("output.txt", "w") do |file|
      $stdout.reopen(file)
      pid = fork { exec bin/"centerim5", "--basedir", testpath }
      sleep 10
      Process.kill("TERM", pid)
    end
    assert_match "Welcome to CenterIM", (testpath/"output.txt").read
    assert_predicate testpath/"prefs.xml", :exist?
  end
end
