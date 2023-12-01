class Purr < Formula
  desc "Versatile zsh CLI tool for viewing and searching through Android logcat output"
  homepage "https://github.com/google/purr"
  url "https://github.com/google/purr/archive/refs/tags/2.0.4.tar.gz"
  sha256 "ce8b4d31d6b56e79808f12a37795ea15127f3e01eb94f2becb1ee1cd8724844a"
  license "Apache-2.0"
  head "https://github.com/google/purr.git", branch: "main"

  depends_on "fzf"
  uses_from_macos "zsh"

  def install
    system "make"
    bin.install "out/purr"

    # This is needed for test
    system "make", "adb_mock", "file_tester", "OUTDIR=#{pkgshare}"
    chmod 0755, "#{pkgshare}/adb_mock"
    chmod 0755, "#{pkgshare}/file_tester"
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purr -v")
    system pkgshare/"file_tester", "-a", pkgshare/"adb_mock", "-p", bin/"purr"
  end
end
