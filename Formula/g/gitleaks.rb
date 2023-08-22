class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.18.0.tar.gz"
  sha256 "dedbfd01223d162c62fb1f271cd25cf48869ea40adcc12b90fc2939d55b27612"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a470333a881bf3a2089100eea80228141debbe866820253d70cd1150001febbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a470333a881bf3a2089100eea80228141debbe866820253d70cd1150001febbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a470333a881bf3a2089100eea80228141debbe866820253d70cd1150001febbd"
    sha256 cellar: :any_skip_relocation, ventura:        "db676643e3bc6cb07331a6497608ad2223d1fb3b2350213a26757e21e442a8ed"
    sha256 cellar: :any_skip_relocation, monterey:       "db676643e3bc6cb07331a6497608ad2223d1fb3b2350213a26757e21e442a8ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "db676643e3bc6cb07331a6497608ad2223d1fb3b2350213a26757e21e442a8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1f1b02e0abc2d722106b2e4cf462e6193a857626181266df7c48f482b1efde3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
