class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.49.1.tar.gz"
  sha256 "969afd0bf9dc6a706b588f455289fb797ca09d2150291030e6c0dec8ed143f08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b8dca0790861e7bc8dba56e19d02cd7b94ad99a0153c08bd225d2c1ad023884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69070efbd46e3a5d9b790acaf8c73e76a00b5c749c6a37d19e1eb4bb2b33d616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a016aacf613be9d45a62ecb6f386fb027a3cdec23ba36097909dab2a8c292ddc"
    sha256 cellar: :any_skip_relocation, sonoma:         "da54fa58347b0ef0374dc59c10bb4a24e80779e2ccb9f75e5434e19a3406e912"
    sha256 cellar: :any_skip_relocation, ventura:        "5291f39fc857375533186c548761a8b916e70d84f8cc17c559d3fc4ae38edfe2"
    sha256 cellar: :any_skip_relocation, monterey:       "fb90ae1535f14d1ede25a09d98f43fafb7ee6db5d31984efcaf2fc42bce2eb43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f703f2506603ed95592d950814dd23515152b44da234fa075b02706acde3b33"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
