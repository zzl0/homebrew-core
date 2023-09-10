class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/04/8b/0899638625ff6443b627294b10f3fa95b84da330d7caf9936ba991baf504/dotbot-1.20.1.tar.gz"
  sha256 "b0c5e5100015e163dd5bcc07f546187a61adbbf759d630be27111e6cc137c4de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7bbc84165aa99de8a0e8f4358ba1cae76386586884bc634cf671e37a08f1dde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd2d0a01695c0a541d06a61a408c4ab5a6632dd782a6ca308509949ecb90adf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2df63cb833e8a1d22f45df268ad4d6311678443ae0c7c8ca089ef76e3edc200b"
    sha256 cellar: :any_skip_relocation, ventura:        "d39ed0c1088d9a9b5eb03cf5cc89127b27848d772726b593419c56642dbd892f"
    sha256 cellar: :any_skip_relocation, monterey:       "6626b3fc132a0a0a849cd231a023b47b19fdcb572497fa799795389408e81935"
    sha256 cellar: :any_skip_relocation, big_sur:        "74efe4cb3e2e2d2387fd3ee89f201492bcd52cfe1df934c2f3866fa1c6762c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efaf9ba7be2ad2d1f3413710dc49d204775941976505a08104cb5d84ff1e561"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"install.conf.yaml").write <<~EOS
      - create:
        - brew
        - .brew/test
    EOS

    output = shell_output("#{bin}/dotbot -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath/"brew", :exist?
    assert_predicate testpath/".brew/test", :exist?
  end
end
