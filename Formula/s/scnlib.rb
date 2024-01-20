class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2a35356a3a7485fdf97f28cfbea52db077cf4e7bab0a5a0fc3b04e89630334cd"
  license "Apache-2.0"
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSCN_TESTS=OFF",
                    "-DSCN_DOCS=OFF",
                    "-DSCN_EXAMPLES=OFF",
                    "-DSCN_BENCHMARKS=OFF",
                    "-DSCN_BENCHMARKS_BUILDTIME=OFF",
                    "-DSCN_BENCHMARKS_BINARYSIZE=OFF",
                    "-DSCN_USE_EXTERNAL_SIMDUTF=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <scn/scan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cxx, "-std=c++17",
                    "test.cpp",
                    "-o", "test",
                    "-I#{include}",
                    "-L#{lib}",
                    "-lscn"
    system "./test"
  end
end
