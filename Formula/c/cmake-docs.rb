class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.28.0/cmake-3.28.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.28.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.28.0.tar.gz"
  sha256 "e1dcf9c817ae306e73a45c2ba6d280c65cf4ec00dd958eb144adaf117fb58e71"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cb04abeabd7a1ff33c9be790089f85d4126599ce36d20783320eb52bcd59d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cb04abeabd7a1ff33c9be790089f85d4126599ce36d20783320eb52bcd59d48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb04abeabd7a1ff33c9be790089f85d4126599ce36d20783320eb52bcd59d48"
    sha256 cellar: :any_skip_relocation, sonoma:         "82ed486ea7933bfdfa73a01c5527a76cf97014495875673cf8393280a85c6ca4"
    sha256 cellar: :any_skip_relocation, ventura:        "82ed486ea7933bfdfa73a01c5527a76cf97014495875673cf8393280a85c6ca4"
    sha256 cellar: :any_skip_relocation, monterey:       "82ed486ea7933bfdfa73a01c5527a76cf97014495875673cf8393280a85c6ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cb04abeabd7a1ff33c9be790089f85d4126599ce36d20783320eb52bcd59d48"
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
