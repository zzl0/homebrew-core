class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/81/09/2a966b33a6a2327b1de9e92d3025f4ba5c45f017d8c0be3fe712b82eee4c/tmuxp-1.36.0.tar.gz"
  sha256 "4c6a989514fb645b66c922975d10c5b94f92879faa97866d550c39988eacee03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06a52b1725cfe8e4216ff1b24661b0d9b6662044187c7d5d3d18f4243e15a6f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "499f663f7083cc42b5f86769964ec2ab8f6f3e6dd05e6adc78faf7ce5a2ffab9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e51951e283aab5b5a1b30fcaa3addcb5642bc85aade2e852b81cf29cef2889"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc3142d13363126a45debc41fca2e32f91cf292868d9ea5358e5191ef3f7d9e2"
    sha256 cellar: :any_skip_relocation, ventura:        "3a2398882e4020fe3c3dbfe5e6b6bb6cb900ae65e6169f8c166dc50265d1d6d1"
    sha256 cellar: :any_skip_relocation, monterey:       "5ecdf60e2ca09ac5842d5d5b16b6522b914c2bb7fd0c60e2d860c0ca8aac1324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f80bb128d6435f15869a74df4851edef2ffcd4f909aa5a2592cef2650a6f267"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/4d/0f/0bc042d2eeff292b69a8c5d42a770dc22fc1bb6d43b589ea9ada9cb304cb/libtmux-0.27.0.tar.gz"
    sha256 "c9da2f027015d7690051f2a29e8313be30c2a876cf68e5082964675edf7b8314"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
