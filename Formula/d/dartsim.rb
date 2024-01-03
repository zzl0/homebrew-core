class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.13.1.tar.gz"
  sha256 "d3792b61bc2a7ae6682b6d87e09b5d45e325cb08c55038a01e58288ddc3d58d8"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "36c717019633611741cba68f1e042cbe9b43da098938350c048bd2c1b7044689"
    sha256                               arm64_ventura:  "4ac5ce37dd161287a9ee8891634beb009a5e36c8ad59e2e605a4b8ae46f7f685"
    sha256                               arm64_monterey: "723eb3c0ddf142fb27fd9eca16696d7cb3a659924e5c6da11a053c049787a7e8"
    sha256                               sonoma:         "de66e0d41ae2635717b07b2ea05ed089972fc1d86fe471140e5be98e6635d928"
    sha256                               ventura:        "7f79fb3bbdd9d1a30849a77b1fb3b3a63c37c65ca22c0d7c5580917253699f23"
    sha256                               monterey:       "9081138a2341c50e3bbaf6d00058be05ec08de3b3cfc0a2cfbcf5970103dfb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e10205517d91581e0c34ca0cce2f8ce917dffa7de561cb46760e8eb142f73c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "fmt"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11
    args = std_cmake_args

    if OS.mac?
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    mkdir "build" do
      system "cmake", "..", *args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/dart/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
