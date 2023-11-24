class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/f1/93/649a0df1df4a1bd643d24e4a2fd002e6749c3a6408cd0bb5f945b666a7bb/tmuxp-1.32.1.tar.gz"
  sha256 "9b8d46a8e66481d8008a4b4107247ade1d004edf3fbed833ed69629b00fe8a94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "875d9e6926a24f07f27916b8c19f64a03230cb8bfad570ec661e8e43ec352289"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3687fac7054536e4cabee90c702aa38e8c9f99520133277f1e91df674ef9c757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076477680ea51b7b27833badfa705fea79025b07663c651ebc92d4f69ceecf01"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9d96a59431b94691b178f44502a35f15bc36e16f085ae43356575715e3035d4"
    sha256 cellar: :any_skip_relocation, ventura:        "e0aff2d9be01c06bd2768b3cab34ac33fd440e822f990b10073e48850e012795"
    sha256 cellar: :any_skip_relocation, monterey:       "483109e0c71970c450135bfde1182417f1b57cc52a55c992c421c7c3c9c45808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c89876d37d5b8c1eb4de615724ca3028a47ca8b15f6f3a22fea646b5c51252"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/99/0b/7af9a90fea74c48714802bb322f577d2df9d2eee7a5da9361e5c7e743e38/libtmux-0.24.1.tar.gz"
    sha256 "de4ab13836023d48e7d7db2b6a18f551b6c848f890c629483fc468f34591cf61"
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
