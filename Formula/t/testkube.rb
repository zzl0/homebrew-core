class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.19.tar.gz"
  sha256 "ec3bcd6e5c85e5e56ebeadc6e899b962246d16d4e7d9547a407b34cf7b127d52"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20866b7b20af0c9d05344268cff272b4b37a6b07a215a688ffc3cecad5790b30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fbf409acc06e85605e5539365063133dc344f545799d1ff8a73e4fb8e5cd5b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6df26177d3022374e089317943ed026990f2048fd116a5a35c88d19adf250aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "aab764ebe0e506450b173eebdc685d237ae6bc07d6dcd03f7fcf5ebb62257794"
    sha256 cellar: :any_skip_relocation, ventura:        "aab171a37fe2d03173362a3fc20dc017d7d11a8b87a759bf531739212caaba5e"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ae545b3479f9790ba78b94ed11b6658a33a573c48504e0f0884ba6205bf80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0889ff831bbcee82ed74c4978e69c80bf2a389a816ec148398de35b471715321"
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
