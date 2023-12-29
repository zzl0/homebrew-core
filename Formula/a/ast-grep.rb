class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.16.0.tar.gz"
  sha256 "523f68b73c534a9881945f30a77b3be2183164d18f41d4b54adf610b925b5f62"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b35dd9e28c31f45a5f311e335e04e5acb4dd2bcf9798e454ec25cfd0432ca950"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63c0d191d55e4803f395f794749e79b93de7b247d0b3f03359bcb95979ff3569"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d03868199752db12c36aab540b306caf4adc8fc9ae788be2ca6929f27ed758d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c3195fd17acf382f67a9b80681cc332dba4423e4559e80743ffedd524bed0ff"
    sha256 cellar: :any_skip_relocation, ventura:        "a8d00d4f73a21fb92d449428f1ffa02aef947871ef05d58ca03c7de11d0ee688"
    sha256 cellar: :any_skip_relocation, monterey:       "da60aa471722fc7279ddbb8a1d1dca3e81925d37a64fae16dab4a8eaec220e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa1b8f409930d285e0a64b284edf2f78a87241c90ea883c057d45c0ff7cb475"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
