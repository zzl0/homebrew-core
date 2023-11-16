class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.10.1.1/patat-0.10.1.1.tar.gz"
  sha256 "f16e93a4199c301ad18fc48d3ae8eb49f6fb64f4550e6629e199249a6dc6ae59"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # Hello from Patat
      Slide 1
      ---
      Slide 2
    EOS
    output = shell_output("#{bin}/patat --dump --force #{test_file}")
    assert_match "Hello from Patat", output

    assert_match version.to_s, shell_output("#{bin}/patat --version")
  end
end
