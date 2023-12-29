class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.20.0.tar.gz"
  sha256 "106aa90fce2c96af6f7cfd55626ed736a988cb9dae639e63aa5854d20914f47c"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90229edf3abee88158cd533a211171a035e46eafe6ee744e694387571dad7622"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7f36a7f3372938eca01fdc59ffeda44d311185a40db337dcafb1110c23c4e8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a695bf6375d8761b25bf1cca7f08c29b4b5b0651fdca9f166372da52f1b2d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4740d87e05cc9d3fefb39c7e417358af5e94ec7866eba7ac7726e8ad045a840"
    sha256 cellar: :any_skip_relocation, ventura:        "7eda2ff1c52ac1decc08629d60ad24cfdfd383e1974c78a36b92fe1429a42487"
    sha256 cellar: :any_skip_relocation, monterey:       "4d8769ffeb332270414f8bcc0ded77ef1af581694e2e86df50d1c51fc0997f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9cae1b761c0e8fd11dbf173447a93449a83d6785661c7b16df23d6114bf5c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
