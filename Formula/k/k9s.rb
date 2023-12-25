class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.30.3",
      revision: "26d1585699fb1faed828161c13265200f83486d8"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34a9f69e05d5d1fdba265f68bebdcd91026895df90bd608db81901744bc5f1b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4c30e736653a39f16c5ab1c899f2f3211c8a0c3d9bd4d972113b19a2f2df40e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcd3db56c1b228a56825f00243c25833cbafcee87a3c60547d5651263008f1a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "015c86f8ed5d1786ff750db34cc851103fdfc4216ac41c894f8d5e73d57a50ce"
    sha256 cellar: :any_skip_relocation, ventura:        "bb7ed620d8978eb897233f086246263792efb53f27f8214cf23d06d1065e683b"
    sha256 cellar: :any_skip_relocation, monterey:       "f551c1796d228c16a9285838aa4fd85e89ef0e8f05a4b6a4793430d9b4452597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a626f13845c408af628a3df7f364b92a71b90ba322f8af24f578265b773c5f"
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
