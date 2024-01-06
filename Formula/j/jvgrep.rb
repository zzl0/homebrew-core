class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/refs/tags/v5.8.12.tar.gz"
  sha256 "7e24a6954db1874f226054d1ca2e720945a1c92f9b6aac219e20ed4c3ab6e79c"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd3fbdc85d5706bd5849c72931fd69c082aa18197b70f1573ea76ed10e4177b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3500cca592776298c3e931471df33ddd104d896132172ef65c3b23a40c97044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3500cca592776298c3e931471df33ddd104d896132172ef65c3b23a40c97044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3500cca592776298c3e931471df33ddd104d896132172ef65c3b23a40c97044"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d3ced0f6941b7fd41399272c7d16cbeb02d0b2c7247398cf518c38419fc490f"
    sha256 cellar: :any_skip_relocation, ventura:        "3a81d099a7a5124558df7a8cd3086ab9ff28ecbe2bbfa6d1efc76c68e993e0ab"
    sha256 cellar: :any_skip_relocation, monterey:       "3a81d099a7a5124558df7a8cd3086ab9ff28ecbe2bbfa6d1efc76c68e993e0ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a81d099a7a5124558df7a8cd3086ab9ff28ecbe2bbfa6d1efc76c68e993e0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f31884bb494544933b0764d6094c64bb6c830be1b57b1aac8621165ae7eb8f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
