class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.58.tar.bz2"
  sha256 "72a36c3cf17d0f624f093d6d083dd5ecaf040c7022bf332148c772008c987a17"
  license "LGPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "16e7d75b0424b550bb56799fd4cdd0e8dce8102cb81080f4949e437721c43ac0"
    sha256 arm64_ventura:  "6d3ad394bc61e38269b16baed4c3aa2046f14d953fd12fe37943820ac33a4092"
    sha256 arm64_monterey: "88a2663c5d20d16afde5494bbf765234965d78500cc04ea97dc02852226a983b"
    sha256 sonoma:         "191f22b4f45d282036c554e98fc7aaf4b6c46bcfa9039530f2778329aaf9bc85"
    sha256 ventura:        "f4f80e7a84707e1178200e96c147e9e4bbddee53c2c6cf8f57284d9dcc5e923a"
    sha256 monterey:       "4b8ab2bc21921916e92e900953c9bef51309f8dad17a524d42f868cf973cd948"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm@1.14"
  depends_on "cgal"
  depends_on "google-sparsehash"
  depends_on "gtk+3"
  depends_on "librsvg"
  depends_on macos: :mojave # for C++17
  depends_on "numpy"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-matplotlib"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "scipy"
  depends_on "six"

  uses_from_macos "expat" => :build

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/4d/70/1f883646641d7ad3944181549949d146fa19e286e892bc013f7ce1579e8f/zstandard-0.21.0.tar.gz"
    sha256 "f08e3a10d01a247877e4cb61a82a319ea746c356a3786558bed2481e6c405546"
  end

  # fix boost 1.83 compatibility, remove in next release
  patch do
    url "https://git.skewed.de/count0/graph-tool/-/commit/0a837b40538df619f43706d50efe0c7afde755a9.patch"
    sha256 "db2a1014c98812bb7121ff69527ce8407bf5a0351241116a160bc1c826d6d514"
  end

  # https://git.skewed.de/count0/graph-tool/-/wikis/Installation-instructions#manual-compilation

  def python3
    "python3.12"
  end

  def install
    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    site_packages = Language::Python.site_packages(python3)
    xy = Language::Python.major_minor_version(python3)
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    args = %W[
      PYTHON=#{python3}
      --with-python-module-path=#{prefix/site_packages}
      --with-boost-python=boost_python#{xy.to_s.delete(".")}-mt
      --with-boost-libdir=#{Formula["boost"].opt_lib}
      --with-boost-coroutine=boost_coroutine-mt
    ]
    args << "--with-expat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
    args << "PYTHON_LIBS=-undefined dynamic_lookup" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "install"

    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-graph-tool.pth").write pth_contents
  end

  test do
    (testpath/"test.py").write <<~EOS
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
      assert g.num_edges() == 1
      assert g.num_vertices() == 2
    EOS
    system python3, "test.py"
  end
end
