class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.4.24.tar.gz"
  sha256 "c79c87021c059fbd234578741f623f28aead5b3355edf0e677995d76b10b741b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "196279a615e7d1446d2222a14cfe938475039d5ca63237e04275f496b81dd835"
    sha256 cellar: :any,                 arm64_ventura:  "129b58db3899ea04eaecb17ad8f8aea065e450c57962a86e18e950d1a47c27c6"
    sha256 cellar: :any,                 arm64_monterey: "da5581b8f9b071474d837cb2542d46a08adc4e3adfe2f9d485a0a66665ecead9"
    sha256 cellar: :any,                 sonoma:         "88c43c99b0b118b724efa4d5d849658301ecc0dd7ca67e1155c3a05748e2ec62"
    sha256 cellar: :any,                 ventura:        "3432f8faa45ec5d812691c531baa9dd58fd46366d75d10b65a1aea63dddd0b6f"
    sha256 cellar: :any,                 monterey:       "33a47aa1f3ae435b05307693e4cd61b109ac98d123d3dccb07b2825f9a250a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df74f101b8378768e9e1860e4414292548d638fc8460b2a37c21c4f93e172fe2"
  end

  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
