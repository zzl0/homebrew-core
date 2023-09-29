class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/8e/97/b285eefe8dd4b030a7e8d216debd4c447110fae7f3934cc0fa999cd93bd5/fonttools-4.43.0.tar.gz"
  sha256 "b62a53a4ca83c32c6b78cac64464f88d02929779373c716f738af6968c8c821e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b1d1a7f04201f9794bcc3c38a042840ec7cd17225bd0cb5db1982becabb2439"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acfa78542160665f0f79a129eefd5471393581ce7b3d8fdee6221e13974d9775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d51d9d8c32ec020e3a8dfebd20d9cab13620d4f5a9c024beeb4dc4f89a7af176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31494f70ec21c16eb45b00188bdabb166f3ec2e41437fc7927e2765be8d203f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "13af5143eaec1c8e5e75c83b8d1d0ad1a1192184846e746ce5163780bd94b284"
    sha256 cellar: :any_skip_relocation, ventura:        "a94b8713d5de261683e8249aed765f212917c7bff1fa2ba5cd6b0563c08fdd6a"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7bce5a88ee88b41dc8c1396638929071aa4174dcbedfeed50523d4ddbf0c9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "34638df5d0d4adc9656b581b58255be27c387c16b287b7cad836d0d7b536b290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6212a1a9be533e156363326265ee948cb50d5757cb534fdc8c0d98a17bdd18eb"
  end

  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
