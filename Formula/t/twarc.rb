class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/8a/ed/ac80b24ece6ee552f6deb39be34f01491cff4018cca8c5602c901dc08ecf/twarc-2.14.0.tar.gz"
  sha256 "fa8ee3052d8b9678231bea95d1bdcbabb3968d35c56a8d1fcedc8982e8c66a66"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb7506c0cc625e7334abf33aa0ea75585a4b9159ee9b4a3b74093e3ac7e453c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4994712d195261523e538a00bc0e23370e3b9488b1651f28bdad0dcfdba80a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f9469f4632f81f4295772fd54cfc2daf92df27059fb02d0f6b9430a4edadd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "928dc144e38ab4fda89acee5dc6f6e9af595e0969eb8e44442d6f42588ade67d"
    sha256 cellar: :any_skip_relocation, ventura:        "e5c9c9cc1937ed80034a1f75a69ef8ba58c5b3678f88c8ae9bbd374351035ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "93b14f6fb25584adfe4e596a93a8a209bf9cd1c77a606ccc80c8955202c599af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d030a541921d513dec68a26d26a6dc9b9899642ba3f9e1cc261229a79fa3f7a4"
  end

  depends_on "python-click"
  depends_on "python-configobj"
  depends_on "python-dateutil"
  depends_on "python-requests"
  depends_on "python-requests-oauthlib"
  depends_on "python@3.12"
  depends_on "six"

  resource "click-config-file" do
    url "https://files.pythonhosted.org/packages/13/09/dfee76b0d2600ae8bd65e9cc375b6de62f6ad5600616a78ee6209a9f17f3/click_config_file-0.6.0.tar.gz"
    sha256 "ded6ec1a73c41280727ec9c06031e929cdd8a5946bf0f99c0c3db3a71793d515"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/76/21/7a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75c/humanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
