class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.2/eigenpy-3.1.2.tar.gz"
  sha256 "1d007a3d32ab60bc39c41ffd7a7baed508c6e933ffc38e7ba76f09b3abb9cf54"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "495c628013c22c14442573018b35e64496cf8012718f8cfba3cedd384daddd0c"
    sha256 cellar: :any,                 arm64_ventura:  "3ca75405594d37c3e8a24748d723cd1cfcbe781a75db6ad4e30c18a12dbab859"
    sha256 cellar: :any,                 arm64_monterey: "f69aeeeb5b918481d9ef5a5e6f1686b8d5d6f265bc6feb7391258b5ac8f59e8f"
    sha256 cellar: :any,                 sonoma:         "f79a1ce52c74b2bcf55160c2be68a2d6f0d445b28a9af7be11c05cdfd30e13e5"
    sha256 cellar: :any,                 ventura:        "20acab8227a4cd679434b6b4af252b5cf2669e64b18e2e27f70eecca3de2ccfb"
    sha256 cellar: :any,                 monterey:       "c1fc10e68de434f8cb12bf77d42dbedb4c2e3dfb274aa3b0b7259057136dd15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5160dbfd31009c46c2a4de94664214f987d16d259525836962714acd4a013eab"
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
