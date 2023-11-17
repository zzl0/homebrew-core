class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/1f/b1/5e3d346a9702a9ca85f50f8c2b61540cedd2ed212fbaccf0d6ad9c7fa269/xonsh-0.14.2.tar.gz"
  sha256 "f31c0fe8f9096192e85df8588a14f8de9ca18b03a9ed7a90c96eff42daefad39"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d42e2ca14aae41731ac3b9288437288f54d7958261345fd3d4452ea53e85423b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c19097123e4a028dc86b05f5951bd6f895d4f7b77709dac413d5b5cb3e1cf0b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e249a5adc4edd4b7ba3b92616276909ef24301c541690ab439a69ca1ad3f3c33"
    sha256 cellar: :any_skip_relocation, sonoma:         "aee1d059f93d0d448c552747fa7b76348ca999963941554e8ba22aed6b13ed33"
    sha256 cellar: :any_skip_relocation, ventura:        "84186d85a66e8c53795cd9cd48902bef0501889e90246ae8d828f14da813fe02"
    sha256 cellar: :any_skip_relocation, monterey:       "365e25d76ab9fade6d1f78309fe7bfe3ea9d5ffaf2338d356501ed146bd5e601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7955d9d80e3ef3b5bea7cd79a95fd6c07759c3414c5e43c168654dcae6feaa76"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/d9/7b/7d88d94427e1e179e0a62818e68335cf969af5ca38033c0ca02237ab6ee7/prompt_toolkit-3.0.41.tar.gz"
    sha256 "941367d97fc815548822aa26c2a269fdc4eb21e9ec05fc5d447cf09bad5d75f0"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/1c/21f2379555bba50b54e5a965d9274602fe2bada4778343d5385840f7ac34/wcwidth-0.2.10.tar.gz"
    sha256 "390c7454101092a6a5e43baad8f83de615463af459201709556b6e4b1c861f97"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
