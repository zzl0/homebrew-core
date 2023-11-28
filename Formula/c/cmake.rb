class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.9/cmake-3.27.9.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.9.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.9.tar.gz"
  sha256 "609a9b98572a6a5ea477f912cffb973109ed4d0a6a6b3f9e2353d2cdc048708e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81d796926db34a08a7e6a190aa26c333a8e052dd6710408c5b38256f5fcf8e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f075ab0a62398e7b798f535881e40e65f50f9f8bf5958cae09d14cd7c779c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38343311c430205492964238b593a6580ce2a8591412faa4a7529a4e8e106322"
    sha256 cellar: :any_skip_relocation, sonoma:         "f282ce633cc87a0dfa65aa5ac6aac012bf83922e24c916479636b3b2131c9cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "2a8db11e1a6ce9e67c91702a3b5f0616ea1dc9c4b2b114ce2999efc8255683e7"
    sha256 cellar: :any_skip_relocation, monterey:       "1021810438b2b2a8ba5f256dcf475c2b7d1ae191e93e73f8d8c39d963cd614c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1517ee62d7fa523b7e241022ba15e88a30e65caec32acaac88ddf3b1635892"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
