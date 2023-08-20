class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/b7/1c/f405fa1db724d192882a1455eefa6f44f15da18127a80d1467260bfa8a39/awscli-1.29.30.tar.gz"
  sha256 "ca96a8090f106c3d18e998b872f1ce9f85565e5e06f142fbf9a1a37b1ff97681"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e17f6b023550d54f77913bc88c87a577c33db91c3468f9b3e71d676d1892099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f792bedad70e33ab83d4fe5216c4ce64a9aa6f4a8e1f8bde040f6d30c3062499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e1d83533bb160a7b3544a30ac2adec6db2ead971b2e4bb1734f8cef63ce1327"
    sha256 cellar: :any_skip_relocation, ventura:        "dd4703b62b71af5ba55cfb078d24d47ebcfeab09e282460fbd73cd44f8c191ce"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d2a66341e1451c72681f0611171843b747a1196262b29bdc1159a04693a7f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3d509d88e2eb4bf4b36302b20a9c3d3de820cf9a261989212e2cb3df49761fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13302f14b2d656e9e73ada5b050699a9e2c6526ab6194c1de0789c80f5d5c76a"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0b/fb/d22ae5b178c0254458d8ef5c089531fc721f57204eb9dbc88f94122744b0/botocore-1.31.30.tar.gz"
    sha256 "3cf6a9d7621b897c9ff23cd02113826141b3dd3d7e90273b661efc4dc05f84e2"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
