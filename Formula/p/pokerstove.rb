class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2bbf42350c3afd84c40a1211420e4cc1345b2048e11758b669089e83cb2d72b3"
    sha256 cellar: :any,                 arm64_ventura:  "354a7b64304cd6c7a0e04200a5eda12393737e7a4a96ce12470fe40ad80ff4ef"
    sha256 cellar: :any,                 arm64_monterey: "6565611ac56460fed1619e63506259fb19ffc5e619715d292d008c6286345bdb"
    sha256 cellar: :any,                 arm64_big_sur:  "612152599b7e4fbe9328967b9770e6bb8bb3cd45a8f07d03c30027633bffa52f"
    sha256 cellar: :any,                 sonoma:         "4917fdc532d22fbd91157cec09b2474d49032c566f7d3b1c2dd35be2a6f04cc7"
    sha256 cellar: :any,                 ventura:        "77d153f1b85e2dc127cc78a7839e58ccfc52d53580665ecec3a56e7faa1e8d8c"
    sha256 cellar: :any,                 monterey:       "4d77e43f1ea5baa87e1b0e226885f86d939819a33ba4c84fd73c47c0e6a8c96d"
    sha256 cellar: :any,                 big_sur:        "8542c066554cf7309317c8fa3be1ccfe91e4056576f0b8f99fef568d5da04f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20618ea7f04f4bf92a7606f18df854a90268948e8f903c1484b4ea9154c7799c"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    prefix.install "build/bin"
  end

  test do
    system bin/"peval_tests"
  end
end
