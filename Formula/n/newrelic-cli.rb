class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.73.2.tar.gz"
  sha256 "67cce52936658a046bcd908486dd21120f7476f76e4a09622e714018e5bef812"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6effc82e1fff4d70c53a13471a55b82443d68a773d22513be73b9705a7060226"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8a5ed20d294df0a78d0d5b1e0277e55ea75535aceb6ae2cda7acec57b2ff09a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec7a92732254065a4ae8752b4a45aafdf57b33fadfd69956dc3adb68b6d2f1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac2d07ed06b0730c21dd9c7350324cd2b8e44fe0d6d48b2c5a98272642016db5"
    sha256 cellar: :any_skip_relocation, ventura:        "c13ba2b0048d69a7d3bfc96b976fbcf3b7ef9786a784bda09d79fb58db7ac85a"
    sha256 cellar: :any_skip_relocation, monterey:       "633d2c33017464ec892818a959d8cd7dceec0a5efb84292f87624b68793da180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9fea29f2c0a85fc46f040797962c7f9ad233ffe04bf8a8514ebd29c2597804d"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
