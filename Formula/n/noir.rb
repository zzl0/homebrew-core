class Noir < Formula
  desc "Attack surface detector form source code"
  homepage "https://github.com/noir-cr/noir"
  url "https://github.com/noir-cr/noir/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "f6c258fe91fc76df4ea9a4ea3c9eb132ebacc7a24a2cfeb7f2932552b94a670b"
  license "MIT"

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
