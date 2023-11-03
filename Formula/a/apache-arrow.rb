class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  sha256 "4eb0da50ec071baf15fc163cb48058931e006f1c862c8def0e180fd07d531021"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f95279f682a197dd7313933f33d5dd89ff4baab0b901a140ee79f5ab72a09559"
    sha256 cellar: :any, arm64_ventura:  "3e0cc5d47cd770b3725d7d81f8fb6fe4cca3c4db754e4f0f8e7d5238678bb0aa"
    sha256 cellar: :any, arm64_monterey: "bd9fe7e42cb0ea918d0eb81b66099de872aaeb0f4b3204fcf732b76ae0570c09"
    sha256 cellar: :any, sonoma:         "65d5c4337d90f145d37e63ffa59f9513001871ca9ef5e59f24b70891312bfa77"
    sha256 cellar: :any, ventura:        "de771d3d2e001ca61350339197562343238a488215c370856527b040cc8644e8"
    sha256 cellar: :any, monterey:       "a15cd023b7a31cbb32c49de26ce9bfc5ec8692b68aff969e19f818b06e1a927a"
    sha256               x86_64_linux:   "ed5c5d7a819ad6e17a4fe652d9977f11c896ddec8d7e2dcad6380a2ec6bf8210"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc"
  depends_on "llvm"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DARROW_ACERO=ON
      -DARROW_COMPUTE=ON
      -DARROW_CSV=ON
      -DARROW_DATASET=ON
      -DARROW_FILESYSTEM=ON
      -DARROW_FLIGHT=ON
      -DARROW_FLIGHT_SQL=ON
      -DARROW_GANDIVA=ON
      -DARROW_HDFS=ON
      -DARROW_JSON=ON
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_S3=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPARQUET_BUILD_EXECUTABLES=ON
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
