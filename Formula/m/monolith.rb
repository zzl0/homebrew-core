class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "cff98122695a9fe922f691d1ff7c75f264ef1e107ea47037bb3287a66ad58da3"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3458f63ad8be5a4df54f76da03350520cb9235ab475de15d87b6b695850a6a5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b8a9ff4180651c3672d23a08752382fc000a14ade5f04d6e2503974b251fc99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f873b4956a0651576a705c015032033a38bd6f09120719597a43d467661b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e265f0cd47917289de249755f104dcb9eb1e9c454d37e954163da7889def553"
    sha256 cellar: :any_skip_relocation, ventura:        "6529c4f0a093cd9ef11991ab0aa14f926f33154be270a17a953567270f0cddae"
    sha256 cellar: :any_skip_relocation, monterey:       "f77d053257388f0dc143b9b34b4ae4a58db88174fed60b8aed4ee47079e5e18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04dfb9e68fc264c539fe83a1375eaafc81921bdda719d243ce8e508df06a156"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
