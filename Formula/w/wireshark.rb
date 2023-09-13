class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.1.0.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.1.0.tar.xz"
  sha256 "9a32ae59f0a843aefd8856c0d208fc464b93ce9415fb8da8723c550c840ab1d5"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "29b300dbfcdf66a9788c47d34b004597b335a0fa337db83ede9fd5058341106a"
    sha256                               arm64_monterey: "dfa02759e46a2d6b9a63c68554de28f5ebc73c39bf297b310dac77f2ee975cf4"
    sha256                               arm64_big_sur:  "1b04324e5aa82f65af4d99f49ace42c0b943d4a9588a46aeb47e0bb53e5ca713"
    sha256                               ventura:        "0127e9ebfb2bbdc8bdeabcd80c1cb657417d05887404e38fd02b59a1112bc69e"
    sha256                               monterey:       "6939bafb4effca4d8397b88fe37cdbf6cc2c30ee05874c47b6ae0035d468c4aa"
    sha256                               big_sur:        "c5b1344c9a6e7553d4356533d75b0e8ac51aa046baf27736bb18c11232c66deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276a65970d0340ba9c8cfdbcf10a56421be409920f02c1c9e02fdf771189cc24"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "libnghttp2"
  depends_on "libsmi"
  depends_on "libssh"
  depends_on "lua"
  depends_on "speexdsp"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libpcap"
  uses_from_macos "libxml2"

  def install
    args = %W[
      -DENABLE_CARES=ON
      -DENABLE_GNUTLS=ON
      -DENABLE_MAXMINDDB=ON
      -DBUILD_wireshark_gtk=OFF
      -DENABLE_PORTAUDIO=OFF
      -DENABLE_LUA=ON
      -DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua
      -DLUA_LIBRARY=#{Formula["lua"].opt_lib/shared_library("liblua")}
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
      -DENABLE_SMI=ON
      -DBUILD_sshdump=ON
      -DBUILD_ciscodump=ON
      -DENABLE_NGHTTP2=ON
      -DBUILD_wireshark=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DENABLE_QT5=OFF
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "Development"
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Wireshark.app with Homebrew Cask:
        brew install --cask wireshark

      If your list of available capture interfaces is empty
      (default macOS behavior), install ChmodBPF:
        brew install --cask wireshark-chmodbpf
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      #include <ws_version.h>

      int main() {
        printf("%d.%d.%d", WIRESHARK_VERSION_MAJOR, WIRESHARK_VERSION_MINOR,
               WIRESHARK_VERSION_MICRO);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/wireshark", "-o", "test"
    output = shell_output("./test")
    assert_equal version.to_s, output
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
