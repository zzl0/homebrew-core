class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.28.06.source.tar.gz"
  sha256 "af3b673b9aca393a5c9ae1bf86eab2672aaf1841b658c5c6e7a30ab93c586533"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"
  # Should be removed with new version
  # https://github.com/root-project/root/commit/ef61c5a6dff06dacff74fc2e15856bbf80b19032
  # https://github.com/root-project/root/commit/01d07d5b33ee91cd7fd6c6e615cd4c940710c397
  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9b1050abd25bea7ee6a9f998a377e09896ea72901d8e927dc90c7afd3c710252"
    sha256 cellar: :any,                 arm64_ventura:  "2f7d577acba62cc976fa3c653eb12cc499054fd0fdc23d96ee1ce61c0792aa2e"
    sha256 cellar: :any,                 arm64_monterey: "6e205879629a898f1a797da87058b2cd7f727b5a5f21742af6227c74542977c0"
    sha256 cellar: :any,                 arm64_big_sur:  "937bc1d4b5613eadde5eb9b8706509ac46fba4b213df914b3a34f0b9645f9e8a"
    sha256 cellar: :any,                 sonoma:         "b057ca509ec4f3fba79c981df6afa36bf09dd707df3aec47e12bd6a6530d0e48"
    sha256 cellar: :any,                 ventura:        "1038f1c50451e93a9195bf3fedd9b206da67c5d0981787ce29ca15c093431931"
    sha256 cellar: :any,                 monterey:       "4738710f5a36f8c52c56650f6a7f6b5ed9470ad9d9fa8f1a5aaf2c9292bcb269"
    sha256 cellar: :any,                 big_sur:        "d5d4d4ce8c56607be1a02cbb2703d396cda084c04cef18be6cd6665364478ab4"
    sha256 cellar: :any,                 catalina:       "13bf91dd19a6a1a2eb4a291cca8cc07e00b79fca07896216f15e09b2ae90a0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5ea379da72fbca8dc6af5079d08dcdec09879a14abb0f1a52b6a9a1cd293f1"
  end

  depends_on "cmake" => :build

  # Fixes missing header MnMatrixfwd.h
  # Remove in next release
  patch do
    url "https://github.com/root-project/root/commit/ef61c5a6dff06dacff74fc2e15856bbf80b19032.patch?full_index=1"
    sha256 "25a5e3fa2846c83e824bd0a21003658f4c03b6096aa52573179c8aea6228a604"
  end

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end
