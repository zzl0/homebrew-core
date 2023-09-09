class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/2d/74/7f9af65f53fda367a82b5355bc8dd55d6cc0320bbc84b233749df3fd58f0/xdot-1.3.tar.gz"
  sha256 "16dcaf7c063cc7fb26a5290a0d16606b03de178a6535e3d49dd16709b6420681"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ec125d9822fb012b35f6edf42243d043c0ba3493abcb752fd9255d2101f8e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ec125d9822fb012b35f6edf42243d043c0ba3493abcb752fd9255d2101f8e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ec125d9822fb012b35f6edf42243d043c0ba3493abcb752fd9255d2101f8e3"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a0b7332146b6a22a1a5c20e76568530ee48377bc43da7e07e2bfa4d4101776"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a0b7332146b6a22a1a5c20e76568530ee48377bc43da7e07e2bfa4d4101776"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a0b7332146b6a22a1a5c20e76568530ee48377bc43da7e07e2bfa4d4101776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171aefa6d629d12a896bc37037afae817dcfd71a4a80285a154ca1729e5657b3"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/a5/90/fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321/graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Disable test on Linux because it fails with this error:
    # Gtk couldn't be initialized. Use Gtk.init_check() if you want to handle this case.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"xdot", "--help"
  end
end
