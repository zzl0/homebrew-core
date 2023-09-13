class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "f10f6e7793f869574b22d0819cb84ad6e7a839513ff0efc0861b4cb3c5a18080"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fa4b89e7cc796053b914ad4749b8b7c76e0e13c1367d41f5eb5d7fd8a90bcfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa4b89e7cc796053b914ad4749b8b7c76e0e13c1367d41f5eb5d7fd8a90bcfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fa4b89e7cc796053b914ad4749b8b7c76e0e13c1367d41f5eb5d7fd8a90bcfb"
    sha256 cellar: :any_skip_relocation, ventura:        "e04e066bf93260f216a7103dc1035d28690b785e96ca45cb089485b3c5748950"
    sha256 cellar: :any_skip_relocation, monterey:       "e04e066bf93260f216a7103dc1035d28690b785e96ca45cb089485b3c5748950"
    sha256 cellar: :any_skip_relocation, big_sur:        "e04e066bf93260f216a7103dc1035d28690b785e96ca45cb089485b3c5748950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b3ee4a24947bfed4354110a6d664482b7c5f222f919e7d3983a469616ce771"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
