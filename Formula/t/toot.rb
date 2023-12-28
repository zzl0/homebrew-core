class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.bezdomni.net/"
  url "https://files.pythonhosted.org/packages/29/97/0236003166ad1e148964104e7d6346a99b687f105bfba84e855043e1dafc/toot-0.40.2.tar.gz"
  sha256 "4c4468e30609cb899a15ef33ce3b06dbd0f45f5a1a93e8e3a49c87140d176922"
  license "GPL-3.0-only"
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e56fedfc65480d5a1835f4ff6a5a7e04ca009d43ca04e13f078dd76d95b2217d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280a9b8dc053a343f8a908af8f16a6a5deac0daea172ec601f66e19685280fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cc616eb43c6309bb7457a7b354ae45f1363182db4445e41dc2a8ebd8f7e2386"
    sha256 cellar: :any_skip_relocation, sonoma:         "8838b813b7223e59eec956f85dd445ab90e57aa7da35a410d7346328224bcd12"
    sha256 cellar: :any_skip_relocation, ventura:        "a2f5fad5a39a339c450ecdd42bc7870a8786d0b3b942c858e29481c09b2a3e42"
    sha256 cellar: :any_skip_relocation, monterey:       "4d78e3f29a22d6873cb50ac38a8cbb963d2681e988003fa3c163fcf28cbb10ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23952439682f56217d056802c57fae8bebe38b6f61c3bd8094feaf0abe7f0c6a"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/97/52/0f9b7a2414ec1fea3aff598adffb9865782d95906fd79b42daec99af4043/urwid-2.3.4.tar.gz"
    sha256 "18b9f84cc80a4fcda55ea29f0ea260d31f8c1c721ff6a0396a396020e6667738"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toot --version")
    assert_equal "You are not logged in to any accounts", shell_output("#{bin}/toot auth").chomp
  end
end
