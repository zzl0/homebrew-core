class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.28.1.tar.gz"
  sha256 "15e94f83e647f7d620a140a7a5da76349fc47a1bfed66d0f5cdee8e7344079ad"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db07f762bf959c55a5d01574e52620b38ade6c5a1a37b374d86151d25be354e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db07f762bf959c55a5d01574e52620b38ade6c5a1a37b374d86151d25be354e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db07f762bf959c55a5d01574e52620b38ade6c5a1a37b374d86151d25be354e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1f308adbd436b59ddf5f071764cf82762719b90f5bfbad4c38f92544e760c22"
    sha256 cellar: :any_skip_relocation, ventura:        "f1f308adbd436b59ddf5f071764cf82762719b90f5bfbad4c38f92544e760c22"
    sha256 cellar: :any_skip_relocation, monterey:       "f1f308adbd436b59ddf5f071764cf82762719b90f5bfbad4c38f92544e760c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db07f762bf959c55a5d01574e52620b38ade6c5a1a37b374d86151d25be354e1"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=share/doc/cmake",
                                                             "-DCMAKE_MAN_DIR=share/man",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
