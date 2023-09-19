class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/30.0.1.tar.gz"
  sha256 "3f4b483b4007762a5ebbda5c12fa828458acde200cacd26832e3e497b1c5c41c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc748fc53237100fd4945021d91f48df08226906c13cc345d0db6d31f103ce52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc748fc53237100fd4945021d91f48df08226906c13cc345d0db6d31f103ce52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc748fc53237100fd4945021d91f48df08226906c13cc345d0db6d31f103ce52"
    sha256 cellar: :any_skip_relocation, ventura:        "349f0c1be36fb425f0f7a6cad2a0ff7ea47e04e15d43f726f85d9e32d5c26a94"
    sha256 cellar: :any_skip_relocation, monterey:       "349f0c1be36fb425f0f7a6cad2a0ff7ea47e04e15d43f726f85d9e32d5c26a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "349f0c1be36fb425f0f7a6cad2a0ff7ea47e04e15d43f726f85d9e32d5c26a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bcc8f998238e6b60ccb5de76e7dff070bb08104351e24bbd5c3d1f390fb9d7b"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
