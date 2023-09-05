class Pystring < Formula
  desc "Collection of C++ functions for the interface of Python's string class methods"
  homepage "https://github.com/imageworks/pystring"
  url "https://github.com/imageworks/pystring/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "49da0fe2a049340d3c45cce530df63a2278af936003642330287b68cefd788fb"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/pystring.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install "pystring.h"
    pkgshare.install "test.cpp", "unittest.h"
  end

  test do
    system ENV.cxx, pkgshare/"test.cpp", "-I#{include}", "-I#{pkgshare}", "-L#{lib}",
                    "-lpystring", "-o", "test"
    system "./test"
  end
end
