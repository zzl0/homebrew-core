class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/releases/download/version-4.1.1/jasper-4.1.1.tar.gz"
  sha256 "03ba86823f8798f3f60a5a34e36f3eff9e9cbd76175643a33d4aac7c0390240a"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87a4d9b99aefd8bf5b2e6fa2b8dcd2bb8b64cbfe63bdf9385ca304e9c7d33469"
    sha256 cellar: :any,                 arm64_ventura:  "20b9d254c9b84e720b0701cffe852447eaec12146aee4fae874ab35c3ae6c4de"
    sha256 cellar: :any,                 arm64_monterey: "f1cecae90f2be7b066e45f0990a4b165a9bde8a1bce4d28f8f1d7954a17770fc"
    sha256 cellar: :any,                 sonoma:         "fa56e2ce9d7893491a4cc4cccefa370cf60cfe2bb15ec84af51fd2e998e65d47"
    sha256 cellar: :any,                 ventura:        "2ae2b923f92d9a017a28e28cedcf9c436a81030cdf152ca7e11615f256f61150"
    sha256 cellar: :any,                 monterey:       "7d58854fb5d6c8edb6f8526373b059b18e329864dbf5baec9391bf5ebb416f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31ae1723b6d2db3eac942de63772c290232ece4ed0e74522d0cf71afaf8c70a1"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"

  def install
    mkdir "tmp_cmake" do
      args = std_cmake_args
      args << "-DJAS_ENABLE_DOC=OFF"

      if OS.mac?
        # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
        # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
        glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
        args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
      else
        args << "-DJAS_ENABLE_OPENGL=OFF"
      end

      system "cmake", "..",
        "-DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=false",
        "-DJAS_ENABLE_SHARED=ON",
        *args
      system "make"
      system "make", "install"
      system "make", "clean"

      system "cmake", "..",
        "-DJAS_ENABLE_SHARED=OFF",
        *args
      system "make"
      lib.install "src/libjasper/libjasper.a"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
