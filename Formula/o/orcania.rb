class Orcania < Formula
  desc "Potluck with different functions for different purposes in C"
  homepage "https://babelouest.github.io/orcania/"
  url "https://github.com/babelouest/orcania/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "66ad797ad62c7cea06a630eb2c0c3b94c47a0e3792c43f0c5403af295eb677b8"
  license "LGPL-2.1-only"

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
