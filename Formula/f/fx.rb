class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/30.0.1.tar.gz"
  sha256 "3f4b483b4007762a5ebbda5c12fa828458acde200cacd26832e3e497b1c5c41c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a124d8a8547a49cb8c4353b2262147cc4b469cc62e86597eb10f6bebf12d5926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a124d8a8547a49cb8c4353b2262147cc4b469cc62e86597eb10f6bebf12d5926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a124d8a8547a49cb8c4353b2262147cc4b469cc62e86597eb10f6bebf12d5926"
    sha256 cellar: :any_skip_relocation, ventura:        "66a8de50abc31177d46e5c8c8e599781ba1f0187512d9dad816e7279ec902079"
    sha256 cellar: :any_skip_relocation, monterey:       "66a8de50abc31177d46e5c8c8e599781ba1f0187512d9dad816e7279ec902079"
    sha256 cellar: :any_skip_relocation, big_sur:        "66a8de50abc31177d46e5c8c8e599781ba1f0187512d9dad816e7279ec902079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a7b1924d36f0c89ac05d8b56766d7af3d7a66f794a44344c3c610ce68cdb18"
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
