class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "1a84ea8a24396ea410d1c88d3126f95956a8799d8eaea0e03dc721e7c65ff9b3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "91a63c4c9297d456aee348f7ff829e8e123ba2068bb21734b0f988ce81d18865"
    sha256 cellar: :any, arm64_ventura:  "dd8aab807e48c4da05eb0e296cf6bc2a8b21a5e652de9910e431334dcc4e9679"
    sha256 cellar: :any, arm64_monterey: "1d1684736a38aab5cffc846519ee371ca0f6acb34b88646ba22a5632f6af8311"
    sha256 cellar: :any, sonoma:         "6d13c20d798b48a79bb55c2f54296a8958b8746256b2c7c378463d87d3240c68"
    sha256 cellar: :any, ventura:        "3f15bb8c32f47c11b3956781a76785a0f41455559af038e6f6e37fed9e977874"
    sha256 cellar: :any, monterey:       "40a71304d1923d5c144a7b6df6175ca48b96c25069b2c14e39a261c540227f43"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  def install
    args = %w[
      -DSIMDUTF_BENCHMARKS=ON
      -DBUILD_TESTING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
