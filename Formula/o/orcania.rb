class Orcania < Formula
  desc "Potluck with different functions for different purposes in C"
  homepage "https://babelouest.github.io/orcania/"
  url "https://github.com/babelouest/orcania/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "66ad797ad62c7cea06a630eb2c0c3b94c47a0e3792c43f0c5403af295eb677b8"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ffdd4597c4a406080c55e7f90ec6b828f4470785a88f728171c8c35cb849d02"
    sha256 cellar: :any,                 arm64_monterey: "2ace03709d138b7f31997e0b234639ab95ad03f5b990109b7c7f38978dd11af0"
    sha256 cellar: :any,                 arm64_big_sur:  "3edaf141533a0dc536a8c15a21f296c4791bb54562a4fdd657772111680aa59b"
    sha256 cellar: :any,                 ventura:        "a7fcd700be673057f42d686f0d70634fca36966e88e1cdde5392e18a678eb661"
    sha256 cellar: :any,                 monterey:       "4cf4296cc33f227e026673ffb6566a76089c83ac4ca975e6cc8149d596769cad"
    sha256 cellar: :any,                 big_sur:        "cc43d837ed6e0ffb20f1203b7f41f47e1d32b7d0415dc81e1becc6eaaf8da815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7189034df3337410a04cc1a9bbdb73f7c97ff165a4f6e1261b6f0c85ade1b137"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    args = %W[
      -DDINSTALL_HEADER=ON
      -DBUILD_ORCANIA_DOCUMENTATION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <orcania.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>

      int main() {
          char *src = "Orcania test string";
          char *dup_str;

          // Test o_strdup
          dup_str = o_strdup(src);
          if (dup_str == NULL) {
              printf("o_strdup failed");
              return 1;
          }

          if (strcmp(src, dup_str) != 0) {
              printf("o_strdup did not produce an identical copy");
              free(dup_str);
              return 1;
          }

          free(dup_str);
          printf("Test passed successfully");
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lorcania", "-o", "test"
    system "./test"
  end
end
