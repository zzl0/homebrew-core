class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v1.0.4.tar.gz"
  sha256 "5e1ded9ad44166cb9cd699d6e379dab67c583a2e9fea43b6bdfa99a13495c147"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c49096b0e815131b7b85486cc91edbbc8c50a5abbe6df1aa04faea5864698da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49096b0e815131b7b85486cc91edbbc8c50a5abbe6df1aa04faea5864698da5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c49096b0e815131b7b85486cc91edbbc8c50a5abbe6df1aa04faea5864698da5"
    sha256 cellar: :any_skip_relocation, ventura:        "5648c60ceaa5c8b19c60840b7845af8bcf71f0ab6294aaff91cbed20660ad8b0"
    sha256 cellar: :any_skip_relocation, monterey:       "5648c60ceaa5c8b19c60840b7845af8bcf71f0ab6294aaff91cbed20660ad8b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5648c60ceaa5c8b19c60840b7845af8bcf71f0ab6294aaff91cbed20660ad8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6cf73cbaa8a88fb6772c1c6eb989c874df929846bf36c705a2e2406e4246435"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
