class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.5.0.tar.gz"
  sha256 "d67529db954b4b8fd708ac984cf79a53baf57ab2d50ef9ee0f9188f7e4a83127"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac2fa8e27755ad26a114e0408526abd4ea59905346d2c06db1e72611fccbd4b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac2fa8e27755ad26a114e0408526abd4ea59905346d2c06db1e72611fccbd4b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac2fa8e27755ad26a114e0408526abd4ea59905346d2c06db1e72611fccbd4b6"
    sha256 cellar: :any_skip_relocation, ventura:        "98bc92c89ba09495a9439d3accf75eff37a2c4087534d0e066dad9d6cad281ac"
    sha256 cellar: :any_skip_relocation, monterey:       "98bc92c89ba09495a9439d3accf75eff37a2c4087534d0e066dad9d6cad281ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "98bc92c89ba09495a9439d3accf75eff37a2c4087534d0e066dad9d6cad281ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa74626275b2e03fa3b5a710b252feb77c7d9b76f1d03688826b59189916117"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match "PDF version: 1.6", info_output
    assert_match "Page count: 1", info_output
    assert_match "Page size: 500.00 x 800.00 points", info_output
    assert_match "Encrypted: No", info_output
    assert_match "Permissions: Full access", info_output
    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
