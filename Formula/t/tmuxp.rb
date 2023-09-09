class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/c3/0c/f8d29097a9e1a0b8dfc874477470bd68009a282f06ef334ad94767649cce/tmuxp-1.30.1.tar.gz"
  sha256 "c94123a0ed19c8c54b120a1d92f386aecf4adaf95184decc10d6441f36c446a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b08d5cfb7defe5147f5e93777b9da4a68fefc82f1f1b884cb268cbd6738dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7ac7fc5bec4cf005370e3b1036c9ecee1258db759ce65a36123b9c54885ccc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cae2daeb1be8a66950bbbd2c294b114ff0725a9890cdc57963e1dcf749fc98a7"
    sha256 cellar: :any_skip_relocation, ventura:        "e478d25ef8bcaff3adb9bd71bdb82a004aadd15446d599ce0c6fbb6b87047208"
    sha256 cellar: :any_skip_relocation, monterey:       "9e369576071f0b78b5048da9d9eaf8f173811b5ade54f325a9794e7e5927cd6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a461c740cb74abfd78418a2bb5cfd75e2f1354d72776607542693b3f563a34a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d66820788e2122fc59c8c428cc594ea574a502332960fd28bc400f5817554d"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/21/99/5f1d5d24a1fbccb79b036bbf0d47f48d5db1a43266082eff8b5eaaf5afe6/libtmux-0.23.2.tar.gz"
    sha256 "eb3e8fb803e4e7c9ce515c93a95145aa6a0b58ddb2ae532daf9fad879609971d"
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
