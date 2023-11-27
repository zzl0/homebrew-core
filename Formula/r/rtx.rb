class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.11.6.tar.gz"
  sha256 "91c726b0063e9e18f9ad76a2836d1459590ffe7559c63cb0836f5dd1423a0b02"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a19e2e2bda84147729fc9217d37c30c6cb1474235243fab8b39ce38559f73ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b22c35f1d188b4109804429e6e089911c668c4147247477b4095cf471fc9671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0d130e84cc46125b7bad508d664077450a34eea5f1c2d6f276b670f30c20fb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "31fc13622bfce08bec278f51901ed9e0f6823f56f7dd4f534c3d89baf775e2a9"
    sha256 cellar: :any_skip_relocation, ventura:        "7692c51d8ab45863a0920fe57419c2de6afcbeb18363e9f2d750ecbb47bc1b25"
    sha256 cellar: :any_skip_relocation, monterey:       "5c0fe3ca43172f6f20fa4a88fe0033024cf4ac855f056f6c160377bfd0385bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b36448a6215d38a5544a928cb1d015cccb4e08ae17b06eec5da52f282b948b0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
