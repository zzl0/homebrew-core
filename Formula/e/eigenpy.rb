class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.2/eigenpy-3.1.2.tar.gz"
  sha256 "1d007a3d32ab60bc39c41ffd7a7baed508c6e933ffc38e7ba76f09b3abb9cf54"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22bd1afd57880fe94ce55854f8ff514e29f1ff6d98d73448073a3f2203aabe8a"
    sha256 cellar: :any,                 arm64_ventura:  "e77da24b8c9927af9607c1267313426664b12e95635c9754b77ad110597471ab"
    sha256 cellar: :any,                 arm64_monterey: "0b2847622a7419be2ecd51cdac2db70845ca7e653de765586498eed58bb58b34"
    sha256 cellar: :any,                 sonoma:         "880892d03f6ad0b584a5dd3a2f8f49a9b59f23cb2dcb8b83bddb1b9e786e0a98"
    sha256 cellar: :any,                 ventura:        "97a02fd20826457e69c9b75f921cf39654dc35b0eefda1ea26a8523e5450c021"
    sha256 cellar: :any,                 monterey:       "198508b15f89003e73dc61be58469b24aa7afffb3277a0a0e5798dd6e68ac963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea69bce1438458b829800d0bc2ab8cd2579a6cbd9ee4058839ec932791a44762"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    EOS
  end
end
