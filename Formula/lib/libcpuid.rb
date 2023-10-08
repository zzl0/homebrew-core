class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.6.4.tar.gz"
  sha256 "1cbb1a79bfe6c37884a538b56504fa0975e78e492aee7c265a42f654c6056cb3"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "ed281b23f1a3aa4d61b95becbac4d154950133491d8c1105dc1f199b2b7b0510"
    sha256 cellar: :any,                 ventura:      "84d3564619410abf63cb5dd759bd5c129d9caf273ab972bc1f04ff4fa3fcb29a"
    sha256 cellar: :any,                 monterey:     "d05aefe01176128d788f2c914d02b8ffc6a111ef2c2e04d142a2c3f3fc46a68b"
    sha256 cellar: :any,                 big_sur:      "35cae66754dd499614f854c21da717fec919aaf7cfd50ea8e0a3c9b83e332a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "583ac04b1bd04fde3501f4f18fa0743f38f2302094f91369963b001349230343"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
