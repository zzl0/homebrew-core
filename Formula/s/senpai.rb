class Senpai < Formula
  desc "Modern terminal IRC client"
  homepage "https://sr.ht/~delthas/senpai/"
  url "https://git.sr.ht/~delthas/senpai/archive/v0.3.0.tar.gz"
  sha256 "c02f63a7d76ae13ed888fc0de17fa9fd5117dcb3c9edc5670341bf2bf3b88718"
  license "MIT"

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"

    stdout, _stdin, _pid = PTY.spawn "#{bin}/senpai"
    _ = stdout.readline
    assert_equal "Configuration assistant: senpai will create a configuration file for you.\r\n", stdout.readline
  end
end
