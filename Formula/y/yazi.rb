class Yazi < Formula
  desc "️Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "e6738a12896ff0ab081a306e6334702a93dcb1039e4c596eb6ee723a6bc037cc"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "app")
  end

  test do
    require "pty"

    PTY.spawn(bin/"yazi") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "quit"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_equal "yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end
