class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/b3/db/450a94145125297929aca586595a8765db0ef15ca219cd47df0337480730/virtualenvwrapper-6.0.0.tar.gz"
  sha256 "4cdaca4a01bb11c3343b01439cf2d76ebe97bb28c4b9a653a9b1f1f7585cd097"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdbc2e8546e743b3c6dfb7a1b36fbbd7c384bdc9e9709718a4301b38d5fdd096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5667ad0ae01bbd6767248e33d3eb0a067820175b1664127d98e4dc802d50a32a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92fcc9f7cc170808b848515b75e05af453fb4d307edcbd0918f6d1303cdcd4a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "90212a4f3322a4eab33a6ceb329aa27aebb0ebd0f1031b9f5062090169d27322"
    sha256 cellar: :any_skip_relocation, ventura:        "9378b61387ad5ef0a55309383543cf46e0fddcac2d15469915695227f828be72"
    sha256 cellar: :any_skip_relocation, monterey:       "b64e5a1c781d187cabe8b86a56212f222c7b0f52a66f6fc67cf18c2948a72384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc5f614c5e25a11817e8f1bbfca5bc871a8ef9d9846d3dd07dd84c556461202"
  end

  depends_on "python@3.12"
  depends_on "six"
  depends_on "virtualenv"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
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
