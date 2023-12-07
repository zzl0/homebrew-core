class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://static.crates.io/crates/pngquant/pngquant-3.0.2.crate"
  sha256 "33f8501d8b81f34cb6f028a5d06772b9d7940e0bc2b15a5d0bce138cb74233cb"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git", branch: "main"

  livecheck do
    url "https://crates.io/api/v1/crates/pngquant/versions"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json|
      json["versions"]&.map do |version|
        next if version["yanked"] == true
        next if (match = version["num"]&.match(regex)).blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b195142b5fad75f621e4103fd147a8008d88d62dbc79cea5681d055ff0520e2f"
    sha256 cellar: :any,                 arm64_ventura:  "55fab88e60676f665814df9e581bdf08fc702c017710b5014b62b71918cc5c5a"
    sha256 cellar: :any,                 arm64_monterey: "2a9880d5f9082fefeaa293e839b4c4c13cf667727f25a051fdaed81d893fd343"
    sha256 cellar: :any,                 arm64_big_sur:  "0ac3705e4b0be4c8fddcf74651060c9f8c4a06cf606cf29487f4c7b1cb54e92c"
    sha256 cellar: :any,                 sonoma:         "abe2eeddc6224a9433f6f5dfc08b6e09cc4e0e65cd58496eb6eb7ad1dca5336c"
    sha256 cellar: :any,                 ventura:        "4d2a131a292a55106feb2513cada8dcbd1b8028ddc59d7bb95a189b2ce51fd6e"
    sha256 cellar: :any,                 monterey:       "fc3d3fd03d19f8ff9dcf2832262cd093bb3716f2362c17e5587930b5f3b974b5"
    sha256 cellar: :any,                 big_sur:        "04f276c7261989d2c5af611cc8ee54e4bd6fe50b7e1f4d5df870564ce7b7f612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d482fb76dc638ad8271269b95af411697e9d1f1ac21abc3f19ceace8af285ea8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "tar", "--strip-components", "1", "-xzvf", "pngquant-#{version}.crate"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
