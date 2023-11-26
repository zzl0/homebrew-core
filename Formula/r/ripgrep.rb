class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/refs/tags/14.0.0.tar.gz"
  sha256 "d4a57f558abe30bb272850d08850d412870fb3f942ed06932a30b4989911360b"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c408d09a5b4ea293f8eed21e27dda6e6faed50b2e30e5fb6b64ebccbe34f46d4"
    sha256 cellar: :any,                 arm64_ventura:  "ca37acadebbf8a719b4f985c484ffd381e0cbeccc73d73673ec116692bf5450a"
    sha256 cellar: :any,                 arm64_monterey: "d21429f4b0a97e94f87cf7588958f53b57bf067876377d6a2e7a30259fa94394"
    sha256 cellar: :any,                 arm64_big_sur:  "977038e704a31a1e362cb737e465324659061857c2fe5a0a7babe8d5d59673c8"
    sha256 cellar: :any,                 sonoma:         "f0727ff4b6aeddff356a3319fe8844dfc2f7435c8ca81ba9bbbeaffd04906926"
    sha256 cellar: :any,                 ventura:        "045b7757f7894aa1091ce0aaf41e58117901b5d6f4893195dd02d2abe5927787"
    sha256 cellar: :any,                 monterey:       "a24a4ab187a9dac94b62c9a4271e6ba434d531a460f886212696bb2e1b5917eb"
    sha256 cellar: :any,                 big_sur:        "f3a112620b217412149aef8d12e54508ce18f96c3f05f2376673f385ca5a0e3a"
    sha256 cellar: :any,                 catalina:       "bab190961709b00de3da9a56ec89396cd773ead7531f62fd2c6756bb2743c9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7bf9e8cee09ae435aa694e1b8942f915f7a9f58ec16a1e0b1fc5f7a76014dae"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", "--features", "pcre2", *std_cargo_args

    generate_completions_from_executable(bin/"rg", "--generate", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
