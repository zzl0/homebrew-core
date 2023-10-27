class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "e153e15de56c91c7c9301f9215fcbdea040ceee97893ed940c0303ee32023d9d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "191bdf7ead0eacae11833b54c7184e03a2b1fd3d30338d559fed2671b8dd3327"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98614be92f0f067d3a3b558a0f3e97b312df135f701f8066e47b3b376751bb20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fce5f5d29220aaf5bfbeda82fe5606dc3c1bff7b593cac316875b278a3cfe47"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4e4801c865ed7d1d26dd95050c6e8f1beb9a0196237fcf241ba01b6b76c8e61"
    sha256 cellar: :any_skip_relocation, ventura:        "da8ae339a37a4ae3ebd5d9a89e909b90d97e70229a172a3340723654a47026cc"
    sha256 cellar: :any_skip_relocation, monterey:       "b0839b3bab9f5f44bf521e056b37244d077980c0dba4d898e6a3dc8353a0d6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c1555312222befe4d6d07860b3be5b0419536d2c816d327fd2600aa5deaaea"
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
