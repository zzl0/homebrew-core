class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "79378668dff6ffa8abc1abde2c2fe37dc6fe1ac040c55d5ee7886924fa6a1376"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d84d2d6b06cb737b2e409fe60122deb0e0a4a8bb09d1713c314015a79302b64d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fplus/fplus.hpp>
      #include <iostream>
      int main() {
        std::list<std::string> things = {"same old", "same old"};
        if (fplus::all_the_same(things))
          std::cout << "All things being equal." << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-o", "test"
    assert_match "All things being equal.", shell_output("./test")
  end
end
