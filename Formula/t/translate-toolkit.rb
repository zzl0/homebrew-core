class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/d6/55/a26b19ff6245f6a84e45f9ff37f3a5d165222d81b8492fa79d34d22e14c6/translate-toolkit-3.10.1.tar.gz"
  sha256 "642e8597c55c3a31b8a6506194f0e64095965d5a1e7e0261d045a2865783a366"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e0c95d2979c9304b006076d0a698ace15c6b9af50cafe1c8bda4e92ba4bb04f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bc369500785df030e4e2c6677f827f223385f836ee6d890c6b00d8945897e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b9d9552c21d7c4c4b15b71656addeb4a2effa84c6ca7e7a6d8b6b22769cdad"
    sha256 cellar: :any_skip_relocation, ventura:        "117f21f4ae2c6f2fec2963381ee7e761afdd7f61c856cc3cb41cfcdd5280c208"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4be1fbab7d91478a80cc6697bdcffa490e72de4efc3172caa0f716a0c5bc87"
    sha256 cellar: :any_skip_relocation, big_sur:        "045881d6da77ae4bde40ffb12d1e98e8fea8166f9d6ebad09cfccfb4588bbb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c196993079297049b8af635b689b9b226ae925dcf7435643c07713820e59929"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

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
