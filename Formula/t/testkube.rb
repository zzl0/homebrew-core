class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.18.tar.gz"
  sha256 "16eacc1ef4345c7344a5b51cf57ee8659c84f7129f0f5c27e27f9fcd6929be8c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2441f447d96fd297dcc8b70c9aab37c70bc8abcd68fad693f9a14db8a6d3e1d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "271e537953e43de5a07d7678c066ebe6258d73a2641e248158c7c203aa9a0f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "911118301053d6ac4e7c0af39835daeaa5034e72a6a42b5152861f5a2626e402"
    sha256 cellar: :any_skip_relocation, sonoma:         "48f81b6dbc000daed331021e63bcb22a99a2921c607d8fa7deac2f77271c55fc"
    sha256 cellar: :any_skip_relocation, ventura:        "86c162d7c3482fcb60cfda56f27e0be220478a0c4ea363b6cb46443dbfb3ef08"
    sha256 cellar: :any_skip_relocation, monterey:       "2d54902999a4580579b77f0c7ad0050895997eb5d391614382bff9b669f0bb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43295977a4f4d53c739ce2e618add78fb8298b99dad7bd7aacab0f1d341b6289"
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
