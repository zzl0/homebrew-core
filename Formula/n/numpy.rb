class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  stable do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"

    depends_on "python-setuptools" => :build
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "7bf09cac32c033c6fa63bbb48ae01311acb68699911cdbf60cc092d02b492fb6"
    sha256 cellar: :any,                 arm64_ventura:  "68b8c9c41814faf053a9678f1d7437688b57594c7a936d91a6e99a85c9a3240c"
    sha256 cellar: :any,                 arm64_monterey: "6fc4819ec74de1824586841c0219f6b4c0b3abff9b1d4f2f00f52c620811795b"
    sha256 cellar: :any,                 sonoma:         "0bf0a6fc222766456866b85b610429c54797c048f905b035a84577d0684f75d1"
    sha256 cellar: :any,                 ventura:        "621ecf8a6c74d4c81e0719acd9586dc7301c5972dba72c6ed6eccb473e179bfe"
    sha256 cellar: :any,                 monterey:       "af1351ee973bbd8381cda31873bbade6920c1e2529722dd4499d1d48b9c065e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f7ec6f5d24dc2636b28753c80d1d5571f1f16ac26391f2a0547fcebb01001b"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use newest python
  end

  def install
    ENV.prepend_path "PATH", Formula["libcython"].opt_libexec/"bin"

    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      site_packages = Language::Python.site_packages(python3)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

      system python3, "-m", "pip", "install", *std_pip_args, ".",
                                   "-Csetup-args=-Dblas=openblas",
                                   "-Csetup-args=-Dlapack=openblas"
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
