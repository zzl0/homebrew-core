class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e8/e1/ff890eed6a5dc5e2b28aee259cf6f93ff8ac3aff8d0e25874109e1b3255c/translate-toolkit-3.11.0.tar.gz"
  sha256 "aa91e5d1901e93bf3495279fe7165ef283eade2feb798a9fe00231bdc2ec5b2a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20a7221f7d8b1de15ef8e2b1014ac2c5158b546acb10e7867f4a5189d19c2f65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0150adf11a02b932e1cfc6943dee67eab4c20406452bf1cecf432090c167441e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f485c4d11c9e3f7fb842fa8e03b60bd9ff11a15b57a44f5d2716d8fe43ac8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a3c944f26d2912e2802b138f99011b0edb3e2b3b8ade60d7f6d09cd57b498cd"
    sha256 cellar: :any_skip_relocation, ventura:        "ece5eebc182b5f3b051f2c81bd83ea4f89ea2b9433be85182809a0b7118dbae8"
    sha256 cellar: :any_skip_relocation, monterey:       "1d21053c278cb1302bdcfdf100a21ab6de905c8cb9081907b2b016a6ede11f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f844ddcd671edbacebbafcaf59eb9310b086659bcc400f2cb0d19971b61634d0"
  end

  depends_on "python-lxml"
  depends_on "python@3.12"

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
