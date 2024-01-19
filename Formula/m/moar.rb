class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "f81b1bdd1d88d5148d39fe6a0e50cdd10418d9ed2ce1ccef68de90bfa088321b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c5eb164fd6d7698a63703316cfd609accbf2b2a8a7e6b0e82cacc248859040e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c5eb164fd6d7698a63703316cfd609accbf2b2a8a7e6b0e82cacc248859040e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c5eb164fd6d7698a63703316cfd609accbf2b2a8a7e6b0e82cacc248859040e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a9510caada0fc608296324c61001ef698576ba10f4136ed4ccc6d0141693c28"
    sha256 cellar: :any_skip_relocation, ventura:        "1a9510caada0fc608296324c61001ef698576ba10f4136ed4ccc6d0141693c28"
    sha256 cellar: :any_skip_relocation, monterey:       "1a9510caada0fc608296324c61001ef698576ba10f4136ed4ccc6d0141693c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c630ea68a57be24f3f6138a07e83387ff9dda3ece7eb6fedadd017c61c0be6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
