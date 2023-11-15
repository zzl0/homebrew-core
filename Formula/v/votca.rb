class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2023.tar.gz"
  sha256 "ac78d2eb5a6694b76878d2ab1ec86bb161765143a447cc23905cdcb2bb6743be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8126c7eb7617240a3f291d78384cc44af121918c16489382da872e22213f398"
    sha256 cellar: :any,                 arm64_ventura:  "9a56a34972be8b73f1141b627cf70589ea122cadeb19460cca669d08543c3f7a"
    sha256 cellar: :any,                 arm64_monterey: "d163159437e27a790e08199bb9a67a50df1d9b64e63921621ffaaf6549d0ef83"
    sha256 cellar: :any,                 sonoma:         "a8b179826b75eb7e537a59dd6396f0d175afc5561bdd50b87883828fd47d2fa4"
    sha256 cellar: :any,                 ventura:        "2498e39368dc9a7d006b91694b52bd84d83dd03268036c1658ec8d54c16e964d"
    sha256 cellar: :any,                 monterey:       "8cb9d1b8da668edd05806c9138aabd9591b24bb5ce79d174d04cf0e2800edfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8137cbcfd0b47d74f39fc02ce7fc8412be8f315cef2df27274c35912f2c566"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.11"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=ON",
      "-DENABLE_RPATH_INJECT=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/csg_property", "--help"
    (testpath/"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system "#{bin}/csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}/table.out"
  end
end
