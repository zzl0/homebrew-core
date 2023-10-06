class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "31e503ad55630c50e34ecc9ed54940986dc06a2fda54e605cc474a36ae5a22b4"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbcbd5aca636f66820844c5cdb625e36aeb607c1bb19959ea60e1f54b747c177"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9901f4b60de7c279d9908107dfc91fd2d4221324b1df4dec846dfe4abca8c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20865f47966b40e3d5806159c34f94eea43199d64bfcd6604fa65e42b99f312a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "272e7ba18bcf20e9439a3dd066b8a406ae3fb9ca7491ca8bad7aa6557d85dda0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec5ce0159535141e1c48c4fd34015c02329c910bba601ee754774cbad4603295"
    sha256 cellar: :any_skip_relocation, ventura:        "011f7b48278df20e169909bc62f5d37fca3798c578af9097f8e5fa301add8ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "ce2fbbc9e8a48878c62a57e5d5beaf14d1d9b9c6e934cc1bce7e757f029a80d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a715672710c200a407107c951f72a384daf03708cd910f48c48b65789a833f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a06efa9973c86316c1702e3ba5155d0850338cbb21aa7bc1d93edfd26ecdf3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
