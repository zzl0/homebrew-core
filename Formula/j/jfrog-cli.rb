class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.52.5.tar.gz"
  sha256 "b437cf855a3b5c66cb180b36965881a0b4bca3b853a47d9366c8e65460366b71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d5305560513c7477df8b3608ff89a6be7a6a9ce3ca70ddae6db7c4733573e6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f66b9909600135d75a575490e0dd10bf4a35baf60a3a28f7d21d16d747cbdfa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e93778973cea16d103af7fb7976d4fd99238ad669c308ad2c39320eff41c6f0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "37c36f487a088310a857059c731841ed7a9069f3c34c5b07e596783dbb959064"
    sha256 cellar: :any_skip_relocation, ventura:        "6b0f81a7a60ffcd9c7f226d08012e77c1beffb6e44889decf4154f5dfa788c55"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b34a82df374a34882f0c00e15c8d0cdeb389188334f32561f1bef02429651a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b122c914113c8b0eaccde30117724576d63c45e5ed5a64836e68d3354c993e75"
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
