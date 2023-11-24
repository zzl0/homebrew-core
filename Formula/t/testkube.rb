class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.8.tar.gz"
  sha256 "ef471e52a7bd4139f0b2a350105e044c4747370b02a1d6d2bb7a7c85c049da8f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c6aa1ec1aaae0fd7eac761b3fd7f9cb1496616a4380ac0a9899471eaf1ba744"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ec8596188956145274e8171aa7013af61d02cd350942891b0e36e67aa66f1b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b67ff36e58bebed0e6bec802401982bedf2a097a81c637370e0f885f0cc346c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bb10b7b1f0fe1b02e18b5f8e1bf2897c9f705ffadb7488d709b663f47112999"
    sha256 cellar: :any_skip_relocation, ventura:        "c0bd8e1ab8f95732e457a999dad12af35472d7857e33226d113ac93b0732ca87"
    sha256 cellar: :any_skip_relocation, monterey:       "030f3c52093c56124362064ce7b3655ff2c663ab82f578381e9327554a60e259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "805bb12a485a659b483e0385265e0dfba3c1e81712467c116aa9c63b8d25d91b"
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
