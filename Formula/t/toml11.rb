class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https://github.com/ToruNiina/toml11"
  url "https://github.com/ToruNiina/toml11/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "36ce64b09f9151b57ba1970f12a591006fcae17b751ba011314c1f5518e77bc7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81f63739751b2e5b61269547bd02ce49fa35bbf57cb85b5e9cf83833489a4098"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=11",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.toml").write <<~EOS
      test_str = "a test string"
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include "toml.hpp"
      #include <iostream>

      int main(int argc, char** argv) {
          const auto data = toml::parse("test.toml");
          const auto test_str = toml::find<std::string>(data, "test_str");
          std::cout << "test_str = " << test_str << std::endl;
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "test_str = a test string\n", shell_output("./test")
  end
end
