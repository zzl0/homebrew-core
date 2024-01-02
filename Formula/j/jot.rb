class Jot < Formula
  desc "Rapid note management for the terminal"
  homepage "https://github.com/shashwatah/jot"
  url "https://github.com/shashwatah/jot/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "d7da3220c29102ee7c51e2a5656ceb6672ae3b85be22c5ddcd176b330c6029c9"
  license "MIT"
  head "https://github.com/shashwatah/jot.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"jt", "vault", "testvault", testpath
    system bin/"jt", "enter", "testvault"

    system bin/"jt", "note", "testnote"
    assert_predicate testpath/"testvault/testnote.md", :exist?

    system bin/"jt", "remove", "note", "testnote"
    refute_predicate testpath/"testvault/testnote.md", :exist?
  end
end
