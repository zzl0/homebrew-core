class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https://github.com/mufeedvh/pdfrip"
  url "https://github.com/mufeedvh/pdfrip/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "b00c01f23f02a067d3fec48ee42d0ed42796fc6f3383537147c7f9dd74257b40"
  license "MIT"
  head "https://github.com/mufeedvh/pdfrip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b91c5633810d0154329c65530b762949d40594dae0c8e5eb6f4ede599653e338"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfdbac5a1186ef16379f695e6b65112fa3a93549d8df59cd1563deaf7b5e201f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a3127e437066e814ca4d4458350793ef7da38d059c0c738e184710057407bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b3faefa6e674ecf90e770a4aae8720eda69fd1d1b2dc532d0524762dc07ae48"
    sha256 cellar: :any_skip_relocation, ventura:        "c232fbe1a2bc4edcad7a20b5df89608bab5144018adfb92ddf2cf5108f75c9db"
    sha256 cellar: :any_skip_relocation, monterey:       "8057bca1c775488e5bd12ea90514465f8977d2851f796cbee92aa2ff16ba6dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58d857cf8ae9061d5516419d0dfcbde4bbed6cedf44861137cf0f9e7afff30b8"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfrip --version")

    touch testpath/"test.pdf"
    output = shell_output("#{bin}/pdfrip -f test.pdf range 1 5 2>&1")
    assert_match "Failed to crack file", output
  end
end
