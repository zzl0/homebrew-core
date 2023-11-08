class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.9.0/mongo-cxx-driver-r3.9.0.tar.gz"
  sha256 "09526c61b38f6adce86aa9ff682c061d08a5184cfe14e3aea12d8ecaf35364a2"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0f0c7760bf03e53e412d1b3c69453b8066af86e178ba968136205bb283796d7"
    sha256 cellar: :any,                 arm64_ventura:  "17a63755ed1dd85d6c7537405286e0739a4e89bb80ae526e5939a70be8cf4daa"
    sha256 cellar: :any,                 arm64_monterey: "d47eda98fce3a5d226a8f64fd9dae2ea54b89207d2bc1430859aec889e88807c"
    sha256 cellar: :any,                 sonoma:         "d52524aa798bb2d424818c2c22e603bdc7b9605d898a1cecf4bcc915e3ab89db"
    sha256 cellar: :any,                 ventura:        "c12c23f3e8492546745fef30ecf6d70866657568ac5adb6a396e2364fb3de66d"
    sha256 cellar: :any,                 monterey:       "f98207bec44964fb4e23e2251cfdb5d9037903e85a8d5f63ef20a5a96cd8507e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b86e42ee0e321012f664de6a3454bc2744f92bcdff8e6b73109c38f9f5441ef"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = Formula["mongo-c-driver"].opt_prefix
    args = %W[
      -DBUILD_VERSION=#{version}
      -DLIBBSON_DIR=#{mongo_c_prefix}
      -DLIBMONGOC_DIR=#{mongo_c_prefix}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx libmongocxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers",
      shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
