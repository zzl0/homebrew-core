class PythonMatplotlib < Formula
  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/fb/ab/38a0e94cb01dacb50f06957c2bed1c83b8f9dac6618988a37b2487862944/matplotlib-3.8.2.tar.gz"
  sha256 "01a978b871b881ee76017152f1f1a0cbf6bd5f7b8ff8c96df0df1bd57d8755a1"
  license "PSF-2.0"

  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pybind11" => :build
  depends_on "python-certifi" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "fonttools"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-cycler"
  depends_on "python-dateutil"
  depends_on "python-kiwisolver"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "qhull"
  depends_on "six"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :gcc do
    version "6"
    cause "Requires C++17 compiler"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/11/a3/48ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1/contourpy-1.2.0.tar.gz"
    sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  end

  def python3
    which("python3.12")
  end

  def install
    resource("contourpy").stage do
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end

    (buildpath/"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    backend = shell_output("#{python3} -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "MacOSX" : "agg", backend
  end
end
