class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "14f4de2d1e8ec465b61315df13274f928364b9d9445675b475faa35c81330b4f"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "239609a34e87b99f0b2daec56da5ddaa729575622ffd3bdafbf0b52f0a7b5851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06090c34a3580bad9abfab95885784978ce8933b7ac9fc57e7aefe9b6aa13a53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51b69fe22afe7c2ff1db8f7bd6f79bfa4d51d92bd98f407814a40362d8dc2f4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0111cd9b3e5327a227eb33e64deb8011cb4a477915871db8de8e1ad63d8da120"
    sha256 cellar: :any_skip_relocation, ventura:        "fe1a9e340156e80bf701f2214a0d765cc258e9b8155dbdf40b14aec9beac1521"
    sha256 cellar: :any_skip_relocation, monterey:       "c398805fd90862fe21d9e9777c174a79015e3ced610df73de0f8ae2aac9b555b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06385e4f7190013ad8ab4779ef37bb135ccf2040dc87dd7bc321da0f21143831"
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
