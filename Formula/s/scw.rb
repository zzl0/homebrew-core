class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.20.0.tar.gz"
  sha256 "d66fe3f13a1cd8f48c601e2370a7cc5b5f7d7e64b22737f005e8de55062ff5aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0de92a93e459db52d4a40911469a6e14aa8ff6876c2cd1d8fda11e16a69ca96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0de92a93e459db52d4a40911469a6e14aa8ff6876c2cd1d8fda11e16a69ca96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0de92a93e459db52d4a40911469a6e14aa8ff6876c2cd1d8fda11e16a69ca96"
    sha256 cellar: :any_skip_relocation, ventura:        "e23b1250dec2cfb1f5b1a483895d7cab2c12302122b376389eed4538105e662c"
    sha256 cellar: :any_skip_relocation, monterey:       "e23b1250dec2cfb1f5b1a483895d7cab2c12302122b376389eed4538105e662c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e23b1250dec2cfb1f5b1a483895d7cab2c12302122b376389eed4538105e662c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbc7c0fd889a07e2b54590dc24a2ec99e379dbcefb7fe19f0ea055bf3727f9d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
