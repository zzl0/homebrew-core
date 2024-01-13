class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2024.1/cp2k-2024.1.tar.bz2"
  sha256 "a7abf149a278dfd5283dc592a2c4ae803b37d040df25d62a5e35af5c4557668f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "afa1c6cdff4809dacea068dac134b2e8e861382d477f110e9bbdd4cc99513acb"
    sha256 cellar: :any, arm64_ventura:  "7bdd89ca6bb7254483dd6bdc185ca3fb524fbd544d61f8d183509b82f41fab80"
    sha256 cellar: :any, arm64_monterey: "cdbcdef206ab2a266eee36142264696fa1ce6e0ecd97a600522d2a54713bbfb9"
    sha256 cellar: :any, sonoma:         "72dcb6262d54fbde7d84104581388ddb54f164c7328479bea63aa085b9f98a18"
    sha256 cellar: :any, ventura:        "4d47f258b198986b4fda6643e1291ee146ea7ad57a3804f6be7853e7cabbed95"
    sha256 cellar: :any, monterey:       "06535d5670667a3254e14b3c1b2865f12d57d1962a19e84db4216c0d53a4800d"
    sha256               x86_64_linux:   "16055b3ba5722c5c73e2404970afb806bf4b72ae932f4e113320211a499ad0c2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  fails_with :clang # needs OpenMP support

  resource "libint" do
    url "https://github.com/cp2k/libint-cp2k/releases/download/v2.6.0/libint-v2.6.0-cp2k-lmax-5.tgz"
    sha256 "1cd72206afddb232bcf2179c6229fbf6e42e4ba8440e701e6aa57ff1e871e9db"
  end

  def install
    resource("libint").stage do
      system "./configure", "--enable-fortran", "--with-pic", *std_configure_args(prefix: libexec)
      system "make"
      ENV.deparallelize { system "make", "install" }
      ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    end

    # TODO: Remove dbcsr build along with corresponding CMAKE_PREFIX_PATH
    # and add -DCP2K_BUILD_DBCSR=ON once `cp2k` build supports this option.
    system "cmake", "-S", "exts/dbcsr", "-B", "build_psmp/dbcsr",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build_psmp/dbcsr"
    system "cmake", "--install", "build_psmp/dbcsr"
    # Need to build another copy for non-MPI variant.
    system "cmake", "-S", "exts/dbcsr", "-B", "build_ssmp/dbcsr",
                    "-DUSE_MPI=OFF",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: buildpath/"dbcsr")
    system "cmake", "--build", "build_ssmp/dbcsr"
    system "cmake", "--install", "build_ssmp/dbcsr"

    # Avoid trying to access /proc/self/statm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    # Set -lstdc++ to allow gfortran to link libint
    cp2k_cmake_args = %w[
      -DCMAKE_SHARED_LINKER_FLAGS=-lstdc++
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
    ] + std_cmake_args

    system "cmake", "-S", ".", "-B", "build_psmp/cp2k",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_psmp/cp2k"
    system "cmake", "--install", "build_psmp/cp2k"

    # Only build the main executable for non-MPI variant as libs conflict.
    # Can consider shipping MPI and non-MPI variants as separate formulae
    # or removing one variant depending on usage.
    system "cmake", "-S", ".", "-B", "build_ssmp/cp2k",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_PREFIX_PATH=#{buildpath}/dbcsr;#{libexec}",
                    "-DCP2K_USE_MPI=OFF",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_ssmp/cp2k", "--target", "cp2k-bin"
    bin.install Dir["build_ssmp/cp2k/bin/*.ssmp"]

    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    system bin/"cp2k.ssmp", pkgshare/"tests/water.inp"
    system "mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end
