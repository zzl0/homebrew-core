class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/69/6b/ee86e017372e384f7093ba5aa15f84ee98148b5d450dc5dabd9e65e579e2/awscli-1.31.0.tar.gz"
  sha256 "6e8d396a8fb95fcdb8d2713153596ce0d8d4a1f62ab9e365e832e10f78f4237e"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a74821ba1a4c3e7695465e28322d0f3fa3045109b73d6549876ec4174927bf94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45f1eea18235ee960bf4b0ab731a4b5580321792e67807b83b6ddd2f10490109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d79985eb4a92881c1a60796b8bb8b944517d700db09534d25f5b638b1a964d9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "81069593c4df9dfbb62edec17a62c8b50917722f6d9c5735e5d3587343ffa0af"
    sha256 cellar: :any_skip_relocation, ventura:        "8e9fe17c36ef3dca48f5b66e1bad2e36879ea91b7ebcfd7a0ab8beb602b33b98"
    sha256 cellar: :any_skip_relocation, monterey:       "7660d0005047e8c4fde6968c1d0fe1ab09b42181ae51050dc2d74ca94f4e1c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f5f9aa0cd5820a4dd4846d2010789f3ab1d9563b295e7754a95218a0072093"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1a/46/06e9194e52bc3598225944152710829c27d257ad0cc6144d408f10840868/botocore-1.33.0.tar.gz"
    sha256 "e35526421fe8ee180b6aed3102929594aa51e4d60e3f29366a603707c37c0d52"
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
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
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
    url "https://files.pythonhosted.org/packages/48/62/53056e8a931a004b9a958c7ca709350a94e212ebcadfc9914a2a8bfaa4ec/s3transfer-0.8.0.tar.gz"
    sha256 "e8d6bd52ffd99841e3a57b34370a54841f12d3aab072af862cdcc50955288002"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
