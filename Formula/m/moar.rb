class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "f130e496f04b0d295b468a3adc17c77c9af1d14ddc54e6001bc3bfabe2f8ee36"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9078fee6f6ca2d2cbf61d88debc906162bb1509eab41fa90e7314f9a6727929a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9078fee6f6ca2d2cbf61d88debc906162bb1509eab41fa90e7314f9a6727929a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9078fee6f6ca2d2cbf61d88debc906162bb1509eab41fa90e7314f9a6727929a"
    sha256 cellar: :any_skip_relocation, sonoma:         "963622342a902adda6d0e70c204235b5544e884d7702085b5889fdccb9f7e7cd"
    sha256 cellar: :any_skip_relocation, ventura:        "963622342a902adda6d0e70c204235b5544e884d7702085b5889fdccb9f7e7cd"
    sha256 cellar: :any_skip_relocation, monterey:       "963622342a902adda6d0e70c204235b5544e884d7702085b5889fdccb9f7e7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a024d2040450d1cbbf51998de6eb28e47cb71e81edd2ee6ec0f51a8c3e0b0c"
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
