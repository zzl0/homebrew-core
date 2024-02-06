class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.6.1.tar.gz"
  sha256 "522db57161bb7df10feb4b0ca8dec912186f24a0974647dc4fccdd8f70649f96"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole-rs", "send", "--code=#{n}-homebrew-test", test_fixtures("test.svg")
    end
    sleep 1
    begin
      received = "received.svg"
      exec bin/"wormhole-rs", "receive", "--noconfirm", "--rename=#{received}", "#{n}-homebrew-test"
      assert_predicate testpath/received, :exist?
    ensure
      Process.wait(pid)
    end
  end
end
