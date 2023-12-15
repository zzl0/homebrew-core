class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.113/karchive-5.113.0.tar.xz"
    sha256 "2da489460198e4c9aabe4734793c97290ecf08f789160fae639ef40a0bba430d"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef1a59d9161f912d6f92b01fd330712abb7122c3a989372d17f61bdd10e8a63a"
    sha256 cellar: :any,                 arm64_ventura:  "0f2041942942186f5fa6f0423e1749e3c29e4372c448f7eb1e9357bcae5c3fe3"
    sha256 cellar: :any,                 arm64_monterey: "8180e09dc6228d69ce6bf084c8d17d4ae10e65573709b4ba738c186b20ecc1a5"
    sha256 cellar: :any,                 sonoma:         "19b29d70a0bc1f3e973c785a60b768118663e149c386286be3821d207d877a24"
    sha256 cellar: :any,                 ventura:        "38536694ffee8b0a138ccaae8bb56ae45a01ac59222b35cf77001fee5f45e9e7"
    sha256 cellar: :any,                 monterey:       "61a85424b952882d0ad6f7beadcf4524ad6478c931d29fa39b3016fed511cad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb39142f0f7e7898a17c355b44f52b15dff3a74ff6caf14a1b99365c0dd5e44"
  end

  head do
    url "https://invent.kde.org/frameworks/karchive.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build

  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "cmake", "--build", "."
      end
    end

    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end
