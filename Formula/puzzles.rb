class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230731.29eaa8f.tar.gz"
  version "20230731"
  sha256 "b3529583109032d75dd909a93e90ac101bd2539bb93229f6ff4f2224d209845c"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e8ef637a80f59f2c2b494ab4f77c95428192f93fe2cdde82deee3f161ddd69f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df590e7c211d88a16acf09e0fd38139eaa6702c13713d6f497718b6cd4c78a83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09bf1caecf6eb2ddbad055670ad81670beb0db4c827f6a52c98d9e3018edfd1d"
    sha256 cellar: :any_skip_relocation, ventura:        "b4466f2fa128f355482fba77b78b0444103925d0270439789d7ee4c786aebe8e"
    sha256 cellar: :any_skip_relocation, monterey:       "e9d67673e3c09cdefd9d084c98ad05ecf2088ade3800e71c713ec48254fa1f16"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2d78f4c4cbf1af8cb9646d835b0312f6a92485411006efef9f48a71e2d39b49"
    sha256                               x86_64_linux:   "5b8425f3548d854b3ec295d08b6034fff8d2258a872873442521fd5a5650c884"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
