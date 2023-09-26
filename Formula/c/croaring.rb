class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v2.0.0.tar.gz"
  sha256 "c93c9e3f484b20e9c5f5c4d8f63f5e7b85953af21a3528e61104dc6186a1eda0"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3c07aff62b06f33e2694bc88f115f3bb317624b5feff1b9339a74a48ba978b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a7f30f00a73af5df4db5147f5a60ec3e338c0a818f7c5f2bc8e0dd38bc2c116"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "846d67ccc243870c8d685b06972584ba3fce338db2f5c555769379477ec87589"
    sha256 cellar: :any_skip_relocation, ventura:        "60c9a133da6a3e4321f522ee0fdfe298ceefc016ec1ae8acd5aacbeacdb7dbab"
    sha256 cellar: :any_skip_relocation, monterey:       "250bbf87c37777f0e5b8ae08d670a1dd52dd3d1d2e8314c167868c94bb1a8096"
    sha256 cellar: :any_skip_relocation, big_sur:        "dce7b366c007a3383f40f1967af800d7d9df3a761126b5778f37ace8d0c30b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0841f110c7a13258a2189d6cbc6b812563bcf2321b87c5c6b51a94ec89e00f14"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
