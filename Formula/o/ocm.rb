class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.68.tar.gz"
  sha256 "2124955b157e9e3d46a50e08ba6c5c9e90a79fa09b7b3475f7c1364748dd474d"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81c93c890bbbd56390d30d6bb921e399fe3bfeb905e0a81f1c4cb620aa0c24b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81c93c890bbbd56390d30d6bb921e399fe3bfeb905e0a81f1c4cb620aa0c24b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d81c93c890bbbd56390d30d6bb921e399fe3bfeb905e0a81f1c4cb620aa0c24b"
    sha256 cellar: :any_skip_relocation, ventura:        "74c5bbf3770372a46800d5d7200fe6a531f04eca74f0e0ac0257a6540035c07d"
    sha256 cellar: :any_skip_relocation, monterey:       "74c5bbf3770372a46800d5d7200fe6a531f04eca74f0e0ac0257a6540035c07d"
    sha256 cellar: :any_skip_relocation, big_sur:        "74c5bbf3770372a46800d5d7200fe6a531f04eca74f0e0ac0257a6540035c07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e010ff29a570026e5294c44cf4f369f019eca5ee2edfc4ae2fd2224338f9681"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end
