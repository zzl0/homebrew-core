class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "bafb96843c7112505238adfd53ff6e393938d0524e1ab4f58eea2b16a75bf13a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf6eade7e61c358fbbf74005eef8720c380c33f1b431dc3869cd96e7545df48e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5dc5ffba96015d6e3be0510fa74390512a5d6d1390783fb1645966cf788b897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16fb249ad43885ce6db2849bd396224f4958a2e17c29f5e276722f9e54fc1f36"
    sha256 cellar: :any_skip_relocation, sonoma:         "d70cd1a0e1777ddc9975171fab226ff57b957b820743623738fdbff61b81bd06"
    sha256 cellar: :any_skip_relocation, ventura:        "a6389dc631851c7b91f28e2f66d2648b563037c2e41654231f1464e05e681ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "3d8d2105a2fa5e043494465b08b1ae0751109c71f77c87d0fd5a6f2419ca79a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c1a9096453785322241af2b2ece254176526afe23555c3bbfff759792cfd60"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
