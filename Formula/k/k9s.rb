class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.30.6",
      revision: "6a43167f1a30db50ed2acd4e3ffcfad25f657679"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ad7a9475708313286882b247ee8f79644406fa08c7a9727442cb95217a26923"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdbbbc7ff6a7d88bf6bdd3ce6c4b1395f8db1a4fdccd9bdc9d001cd10b0edfc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c0550b0f7bcb88e9deef05a5c20135eadaa2b31b594b725ebea3893f4c556c"
    sha256 cellar: :any_skip_relocation, sonoma:         "631ff6262d156389c7d945a455a16454e92b0d021d7d3eda1f226e081d6f9b05"
    sha256 cellar: :any_skip_relocation, ventura:        "1d71e706e1a348db12b1bb5cf324f6d5b41d20b60b0863eac13ad27424e00120"
    sha256 cellar: :any_skip_relocation, monterey:       "c927b25a7600952bd439fd3bc792699dd7ae1473506a2e81afb076bcd8cccbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f7a622d4e0d4b76fc89439338dd84e6586dd1826effb01759c3edcf3be6630"
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
