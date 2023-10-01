class Smlfmt < Formula
  desc "Custom parser and code formatter for Standard ML"
  homepage "https://github.com/shwestrick/smlfmt"
  url "https://github.com/shwestrick/smlfmt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cbbdfbcf1f929c6e933a2e4f7a562bf71b0709ca9cd2888bf58a53c4ac0240e5"
  license "MIT"
  head "https://github.com/shwestrick/smlfmt.git", branch: "main"

  depends_on "mlton" => :build
  depends_on "gmp"

  def install
    system "make"
    bin.install "smlfmt"
  end

  test do
    (testpath/"source.sml").write <<~EOS
      fun foo x =     10
      val x = 5 val y = 6
    EOS
    expected_output = <<~EOS
      fun foo x = 10
      val x = 5
      val y = 6
    EOS
    system "#{bin}/smlfmt", "--force", "source.sml"
    assert_equal expected_output, (testpath/"source.sml").read
  end
end
