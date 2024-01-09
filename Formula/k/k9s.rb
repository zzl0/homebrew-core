class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.31.2",
      revision: "65100b05d98d290a34359b1573723baa620c71bd"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8c6db7d5dc9b6cbf8593790d1778d660811fc12cc8c1a0678f987804ba5d387"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e8813879115490c159ec173b4c11d8ecf64284b1919c3d17278d75419cb63bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "607db711cd0fb075e5a9665beb215632a6001f9682093ff2c579893ab3bc0400"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5b2673f829641d2919e8eec224d6b0d047ddae5c229827771005d539a4ab6ea"
    sha256 cellar: :any_skip_relocation, ventura:        "6c855cf7105dd23bcf221b761ab90737aca69703da2b363be08883a61aed7578"
    sha256 cellar: :any_skip_relocation, monterey:       "6ec9ea6242d33599099c14559eb051e080511f7dd873d0065f9d69b7f2781c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0e7996ddca29282e552d75b8b471b7d3f9de1d842a788bc656f3a1cd17e34e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
