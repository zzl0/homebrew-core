class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/c1/6b/2f05d73b2d2f2410b48b90d3783a0034c26afa534a4a95ad5f1178d61191/virtualenvwrapper-4.8.4.tar.gz"
  sha256 "51a1a934e7ed0ff221bdd91bf9d3b604d875afbb3aa2367133503fee168f5bfa"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7add37594bf1a23cbec7e571fb51105fc137009baf9108f4e19baf00ee579ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80f02cd26fd8255fe1aa39e774bc06eef77ecad1988a86e61f37c97604ae645"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80f02cd26fd8255fe1aa39e774bc06eef77ecad1988a86e61f37c97604ae645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c80f02cd26fd8255fe1aa39e774bc06eef77ecad1988a86e61f37c97604ae645"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f29c186cc9471ad7a95f6db992ac89b188814457a6c76da6f591ec8a20dd5fb"
    sha256 cellar: :any_skip_relocation, ventura:        "7972ca432197ee167f1eadafb627fdc439f04372cbd75fbe6da1e57acfa6f282"
    sha256 cellar: :any_skip_relocation, monterey:       "7972ca432197ee167f1eadafb627fdc439f04372cbd75fbe6da1e57acfa6f282"
    sha256 cellar: :any_skip_relocation, big_sur:        "7972ca432197ee167f1eadafb627fdc439f04372cbd75fbe6da1e57acfa6f282"
    sha256 cellar: :any_skip_relocation, catalina:       "7972ca432197ee167f1eadafb627fdc439f04372cbd75fbe6da1e57acfa6f282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1e7e70bf54e9a98a19dcc888b18c0233e07bf7cc70232cd451b478fda24a8b"
  end

  depends_on "python@3.12"
  depends_on "six"
  depends_on "virtualenv"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install_symlink libexec/"bin/virtualenvwrapper_lazy.sh"
    (bin/"virtualenvwrapper.sh").write <<~SH
      #!/bin/sh
      export VIRTUALENVWRAPPER_PYTHON="#{libexec}/bin/#{python3}"
      source "#{libexec}/bin/virtualenvwrapper.sh"
    SH
  end

  def caveats
    <<~EOS
      To activate virtualenvwrapper, add the following to your shell profile
      e.g. ~/.profile or ~/.zshrc
        source virtualenvwrapper.sh
    EOS
  end

  test do
    assert_match "created virtual environment",
                 shell_output("bash -c 'source virtualenvwrapper.sh; mktmpenv'")
  end
end
