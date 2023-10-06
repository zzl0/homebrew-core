class Urlwatch < Formula
  include Language::Python::Virtualenv

  desc "Get notified when a webpage changes"
  homepage "https://thp.io/2008/urlwatch/"
  url "https://files.pythonhosted.org/packages/ef/6d/28df22a0912d40e294cfde709ead82e36441018ff9c0137c9e768ce9084e/urlwatch-2.28.tar.gz"
  sha256 "911df3abbd8923e46ec167a9657a812436caf93f7f9917cb7c95ebd73d28cce5"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2df1b2813ba9f42cec41dc2c051986d79ab02e80cfb5c3c9522a75096e24bd8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55592654f29d94fa3e5c470fab6ccb2c152b8852880dbcf80ef470242b428ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4d64c1516c4b8abdaf30633c4a03ba930495cdd6e0108d4c672dff294448a20"
    sha256 cellar: :any_skip_relocation, sonoma:         "80304a5d0e2d191d4ca4f7571bd62ff7aa29329b4b02cd132296045dde5e21aa"
    sha256 cellar: :any_skip_relocation, ventura:        "1200dc7c4a1b01bf633751875eaf6e7aee69d037fca3b692da9d4465e19aa68b"
    sha256 cellar: :any_skip_relocation, monterey:       "138b9c1ec5569d643d1b5a00363bf5a4e127aa53ed4903b6277b12821b83099a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d62b12461c99498a1e19f57e5f11b4410d3640b35ab92f4eb173e599a431690f"
  end

  depends_on "keyring"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "minidb" do
    url "https://files.pythonhosted.org/packages/20/d4/915ac3b905cf33f3a0df5c92619fad66ae2e23cecd8f21dbfa76a9a27133/minidb-2.0.7.tar.gz"
    sha256 "339fd231e3b34daecd3160946e0141585666ac57583882a14c4c69e597accca1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    paths = %w[keyring].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    (testpath/"config.yaml").write("")
    (testpath/"urls.yaml").write("")
    output = shell_output("#{bin}/urlwatch --config #{testpath/"config.yaml"} " \
                          "--urls #{testpath/"urls.yaml"} --test-filter 1", 1)
    assert_match("Not found: '1'", output)
  end
end
