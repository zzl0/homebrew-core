class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3720stable.tar.gz"
  version "3.72.0"
  sha256 "f0fb7ec3b772da5484390d5af8abdd96385f723c653dc9bf0f6dba97574260d3"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6c1550ecd1d49686b51849136f3d7bbaf5addc65e11dfa774e214475918d4e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc31950b2395d73ab39f7132a5407e2319e4d715aaaf99a877afe476c754130b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d3885af22e51e9f0e7cb71a942c760640d620967820d3be71abef5f66c1836c"
    sha256 cellar: :any_skip_relocation, ventura:        "de25a8dc081c2f2889d7a3cf82ef6a77bf51c7b576b05094d7fe89bddd53516a"
    sha256 cellar: :any_skip_relocation, monterey:       "df11cfa2cfa6379eb9a20bfb674fa3696f821c94da86f7d4500ea6adcbd3d459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083b0dbb2da20d6a6cf3e343e94cb11df0925ec9d2cbac60640b4c190662790b"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
