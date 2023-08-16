class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "bad499faec7533c460e72c121716141f8cca0ea613ed55143ba1780b06a49b9a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "df447c2ae8b3fc9f9697c39c934265c45bbb910757973ade6ba3ff40f54f5216"
    sha256 arm64_monterey: "70e9ad8679d64908a03670a671670dedbeae1711f9d66e68d95670ab1161d6f8"
    sha256 arm64_big_sur:  "062476c03b8f68f2bcbef933e323fe6e01a7e0afc565f494d45edd8f7bc0aefe"
    sha256 ventura:        "e9d886c2bf5be3fbc692d94e5c0c5040370efeda60cbfe38d575f97910e0c21c"
    sha256 monterey:       "32d57276d9bd1f9379d1c90e3722696cf7643b6c81b52c9ee2b94b9cef4fa8ff"
    sha256 big_sur:        "e89c5695aaf36dc9a7be755bed644a36985784a3e01c974672e198332de15e03"
    sha256 x86_64_linux:   "fb8dd4f1683d5a796416977e4722ae1a1a2cf227041ce253e5735c44983c5831"
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "qt@5"
  depends_on "yaml-cpp"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_UDEV_RULES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"config.yaml").write <<~EOS
      radioIDs:
        - dmr: {id: id1, name: DM3MAT, number: 2621370}

      channels:
        - dmr:
            id: ch1
            name: "Test Channel"
            rxFrequency: 123.456780   # <- Up to 10Hz precision
            txFrequency: 1234.567890

    EOS
    system bin/"dmrconf", "--radio=d878uv2", "encode", "config.yaml", "config.dfu"
  end
end
