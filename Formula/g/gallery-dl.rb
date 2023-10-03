class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/a8/73/93eb9fb5e296700470108495ec128708b8e15a09f3cd32145a3b7b6f4a12/gallery_dl-1.26.0.tar.gz"
  sha256 "fa0e2d7ebed117daeb8a641c5e1733de8fc2c7dc4b36b4c3575171ed74b187b2"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7be2b6ed5488271648377baa40738cd9189fff36094b66f978e1a6698df48bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15809a724a7ecb8460f6b1a31a8c3dd487d3db3ae855f4ef844eb629595e0ca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772197c1740c4a4cf76a6800c41335c5169b8ca07a25e3a226194d679df7390f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54504ee2a636e07985a2fc781693cfafad7961432f58e8a81a419aa9bd47d28b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae17fb0d78a71a75c4e3cba9a9007b6d7ace7b56aaee3f455e550de6aa1e90d9"
    sha256 cellar: :any_skip_relocation, ventura:        "ea3994b29450abe1c7601003f04aa3203b730c0351c707e70febd8f4e67b680b"
    sha256 cellar: :any_skip_relocation, monterey:       "f48275647e74622d59965f9bb1d7110ee7aa95f4022ade1dd72155b3c7e09989"
    sha256 cellar: :any_skip_relocation, big_sur:        "c566b11083df7d8e1d915ec1d626669055694ae797da5b0bac67c7cd0fe50e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da6c094ec16f44a23a35d4e8dcb4895eebede063af843067015dd057053425d"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
