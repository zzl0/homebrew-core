class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.4.tar.gz"
  sha256 "0a905ca8635ca81aa152e123bdde7e54cbe764fdd9a70d62af44cad8b92967af"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9832fedc6b29ed4aeab8f3edacf0ca754321631b9650eb00ef77bfcbbf2a3262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9832fedc6b29ed4aeab8f3edacf0ca754321631b9650eb00ef77bfcbbf2a3262"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9832fedc6b29ed4aeab8f3edacf0ca754321631b9650eb00ef77bfcbbf2a3262"
    sha256 cellar: :any_skip_relocation, ventura:        "b16b045403a26b503f002d64c91c7e1ec0b55cee0d2bed1e402ff79fc22332f5"
    sha256 cellar: :any_skip_relocation, monterey:       "b16b045403a26b503f002d64c91c7e1ec0b55cee0d2bed1e402ff79fc22332f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b16b045403a26b503f002d64c91c7e1ec0b55cee0d2bed1e402ff79fc22332f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9832fedc6b29ed4aeab8f3edacf0ca754321631b9650eb00ef77bfcbbf2a3262"
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
