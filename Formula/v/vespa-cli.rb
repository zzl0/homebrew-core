class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.221.29.tar.gz"
  sha256 "84293ed8fdc04a59e20f9f2440989a4ffe5e1fa0c00fd385dd7e50ab828d2c91"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7357d417fd346dc7cd5cc2c94b4b79fa460ffc7851066b455a36f2ddd20becf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae74cac46015ffa1d9372349fd7c18345c00a1c073b3510a31547eb891c816c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e6effc462cd454e5b1908a653323a0a295d79e774cdcfaa00e043985a0a97b5"
    sha256 cellar: :any_skip_relocation, ventura:        "653e76846002d22fc03b503c3567a4488eb56af5d0bad512c68d69be5504759c"
    sha256 cellar: :any_skip_relocation, monterey:       "38f0a55023ead94db0399655b6f2dfd7b626c3bdc0dee72738b900071ea9d21b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7057638b53f79e9e1db7d14e186be3f3637ae6ddbe2020b9cadacfc9ed944e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbda7573813cf863a33e25c4f511d7f21e9db2dc7ce63d6fbe21ce253f51e4a5"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
