class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.15.tar.gz"
  sha256 "45e052f250d9d9ebe79a1f0769720734007418acdeba49ab52325f7c425c0e7d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eeb81f6ff2f801090339255de6f0018fc580764916c194740262ffcd9f6d680"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c241e36b468b4114a35286646d1e8654da09b5b21012a035e9daac9b8247809"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ad35ffea5716c942345471f8024e6dd3e5ef62b0834e4128ddcbe3cb3650bf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fa749fa2499431d1b61b73941d21c56d4dea1a3aa5b0439173c854bed8c382d"
    sha256 cellar: :any_skip_relocation, ventura:        "e66c5a61b35689ff02a67194c699d9ebb64de575810827a119976a7cf5f4b739"
    sha256 cellar: :any_skip_relocation, monterey:       "3b49bb2b5a57b3a67d0a1fe56b838563075d0cc56cb1a79aec9d638c36add2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63042c0ae3f235fdd346c58e31385a120132e75091773cc74127628918bac02d"
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
