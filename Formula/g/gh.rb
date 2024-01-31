class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.43.1.tar.gz"
  sha256 "1ea3f451fb7002c1fb95a7fab21e9ab16591058492628fe264c5878e79ec7c90"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d2a5a72b3656b9b0acb81968755fa11f6bddabc8d4b52fc62bc25c66f4c9b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25c067c51a4295bd36a5ebda4fd061c6a62bc594b0cb063b0807ad20f582e236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2c8fc1a8df538c9ec6a543040dab23a1292070f4d6ddc8b244a3440df85951f"
    sha256 cellar: :any_skip_relocation, sonoma:         "65bcf718b3f0b259c506adbf92da2e2ef13a2544cb5ab878061cea216d15514a"
    sha256 cellar: :any_skip_relocation, ventura:        "59e1d4c43da50e3c341a603c2f42438eb5c424fc3682d5d864d25de237a07ffc"
    sha256 cellar: :any_skip_relocation, monterey:       "edd46cf0073aa351e9ea9cdb259c77a03a2489033cec8b36b8a3f9be320316eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e6c751d760175056ef02797457ce69f724824076b7f735db74b8f1acc5f434"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
