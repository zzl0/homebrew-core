class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.8.tar.gz"
  sha256 "85e10e7acf0a9d9a3b891b9b108f76e252849418c6230daea94ac429af8a4ea4"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36a026337dbae0bd3cc6c0c6531088a82185f7b502e4b2adfcb8e6ba1a41bc53"
    sha256 cellar: :any,                 arm64_ventura:  "b2ae227b39a1269254fb914ff36fc8c1afcd1643e3dd3663bae3c965f78f0575"
    sha256 cellar: :any,                 arm64_monterey: "88810428d4cebbbc74c4a640e4307b8bdf0d48150af8b2a4d9b6559e21f0f2f4"
    sha256 cellar: :any,                 sonoma:         "85b37dc475189c708465dd9709bb63db6a9b8a37a0db9ec01e7f9e0845ce7e86"
    sha256 cellar: :any,                 ventura:        "4fea378372b1d5cdd4bc458b7f645e92a94701cfdbfffbb2a38dc243153267f4"
    sha256 cellar: :any,                 monterey:       "49aa546a8661f2f3a1a36587dfc20d32d16456167f5642078e5690d9f6149f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d590f6120d25ac7d2abe3a1fbd5fadc8cedcd6161bef5fbb406c6707b664c9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "openblas"
  depends_on "osi"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = %w[
      -DUSE_SCIP=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_lp_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_lp_program"
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
