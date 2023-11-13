class Biodiff < Formula
  desc "Hex diff viewer using alignment algorithms from biology"
  homepage "https://github.com/8051Enthusiast/biodiff"
  url "https://github.com/8051Enthusiast/biodiff/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f7960914ccf9b5fbdf3188b187d0cd3bca00f211487aa01d7b6f580da1c32312"
  license "MIT"
  head "https://github.com/8051Enthusiast/biodiff.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    begin
      (testpath/"file1").write "foo"
      (testpath/"file2").write "bar"

      r, w, pid = PTY.spawn "#{bin}/biodiff file1 file2"
      sleep 1
      w.write "q"
      assert_match "unaligned            file1  | unaligned            file2", r.read

      assert_match version.to_s, shell_output("#{bin}/biodiff --version")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
