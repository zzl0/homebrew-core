class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "455fa11d65e770afc7b37864b385d49a020b61969e714bd1883d885265ff9832"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f795c798a18b921d8b5a003fef0298df045b713f771c001d942d6e6e9738199"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f795c798a18b921d8b5a003fef0298df045b713f771c001d942d6e6e9738199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f795c798a18b921d8b5a003fef0298df045b713f771c001d942d6e6e9738199"
    sha256 cellar: :any_skip_relocation, sonoma:         "f32f7384e83b6070ce1a3759266c5278a234769502d955bef06c617c72ada2a8"
    sha256 cellar: :any_skip_relocation, ventura:        "f32f7384e83b6070ce1a3759266c5278a234769502d955bef06c617c72ada2a8"
    sha256 cellar: :any_skip_relocation, monterey:       "f32f7384e83b6070ce1a3759266c5278a234769502d955bef06c617c72ada2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416cde871178151cb1692b56b04e2456b3f49204f32857013d1f6be1cb0ec75e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
