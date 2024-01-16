class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/44/d4/e3f8e6db5db554a6318690acdd5b93f973a625f8fd36008f826f042a910c/xonsh-0.14.4.tar.gz"
  sha256 "7a20607f0914c9876f3500f0badc0414aa1b8640c85001ba3b9b3cfd6d890b39"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8be451acdb62d38e6e1a31c211c60dbd8234a0dfc60746effba2135090a46337"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b568543eaaa9e8661486196663c67cccf9d86390ff113abe14dd557d71be729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd8100a3fa0a13da7517f0b7656e149c040721786c67fe526b5181aa6bee2f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "08047ab2ee32821a18016da39fb82776c8a170df547fd1c71231b68733df6d87"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4a09e423c0a183deb9611ee990e3d198cbea08221015ff60acf90a13b378b1"
    sha256 cellar: :any_skip_relocation, monterey:       "5b15ef4c475d25341643cf25285d8331d2869bcf323266ac732dfaeb274d9dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "269e46ad6d9b9677f3af9702cb1c722870f8bed112aac1e10384fa4c60447c8e"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
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
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
