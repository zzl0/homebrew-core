class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.8.tar.gz"
  sha256 "bbc1b5fdfec7d0f83c6a9d24bf90d10c2a462f30aa1ced30bed72288006a2194"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "82245a0d3e5c18e1a6ff3e1fe271779c05b5466d87362dac65708a2e5056f2f5"
    sha256 cellar: :any, arm64_ventura:  "a05b077106f69aa96fc808c4a4228dd39fcfedf5e06ff97f16d7aaf337d9d8c0"
    sha256 cellar: :any, arm64_monterey: "a3fbfd4feb2cebd85da47265df53ad15ed37e40d42f218a7462ae0e32cfde9f0"
    sha256 cellar: :any, sonoma:         "830558bf63d611014736c288c4236505bc095b0eb914b3147b9fdf85c5b54ef5"
    sha256 cellar: :any, ventura:        "2f8981841ab10c25e06fedb072d6cd94e43e1d4d0e56f28a127e13bf67c01408"
    sha256 cellar: :any, monterey:       "6272fc94fa380951f147c60c7f8af567a79abb7b8d96a5ab4568dfb75a886f21"
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
