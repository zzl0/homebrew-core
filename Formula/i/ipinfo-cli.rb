class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.3.0.tar.gz"
  sha256 "18069e115c78a7a167311ad02de354c8e8d71dc63d838d94635f439eb64585f0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fdfde8ad46e5468179ab530b3ffb804a753176b92f699cba013d11ff6d0c1eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7823d9236b678e10e05cfe66b49ef546ed182e8b112b768ed7291180751cba36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d9110df5d885234ccd7a270aee24e1ecf19ac1c7ecbb68b00375b6d223caa1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ad504858488a166b7595aff10a4cbc6a10c76c18f45bf0cbf2d3765f843cf10"
    sha256 cellar: :any_skip_relocation, ventura:        "cd48387df844279d38526f385de57f6ce11ecc2f9a23a7d9a617274cb81ba108"
    sha256 cellar: :any_skip_relocation, monterey:       "3497cf1674511bffb8b5995cd72487ad4c6f7fa0c4553f9616bc2736d7be2e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e9ffcc6997ad12d94bb887c8f086083ea580f0aa9af0e9b43891fae8dccd06"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
