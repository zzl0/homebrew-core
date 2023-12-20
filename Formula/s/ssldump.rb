class Ssldump < Formula
  desc "SSLv3/TLS network protocol analyzer"
  homepage "https://adulau.github.io/ssldump/"
  url "https://github.com/adulau/ssldump/archive/refs/tags/v1.8.tar.gz"
  sha256 "fa1bb14034385487cc639fb32c12a5da0f8fbfee4603f4e101221848e46e72b3"
  license "BSD-4-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "8fc8ca0f4b1fde91e0b45420c7a49400de0a6b350a2745c493914b19558dd734"
    sha256 cellar: :any,                 arm64_ventura:  "83eb5a5e9b13ec2a5dbd1d0476b58e803318ac8243939997c91c61b08af6a705"
    sha256 cellar: :any,                 arm64_monterey: "db2444ab2212b47e715351f51179244c4c141890f4b04af950fdb715668a3acc"
    sha256 cellar: :any,                 sonoma:         "15554437c179041d78da4e2e64b9cf777f8b8f630d76e334f9ac3dac7d313a94"
    sha256 cellar: :any,                 ventura:        "bae2a0625a830a84b52bc1067f0cbc2a97cb7bc699ee1a47a59edfec4f54248a"
    sha256 cellar: :any,                 monterey:       "52da057720aa30c60b9a3ac7be09f9e5337ee3b1123108d44c5901e425a19bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6e48e727151bd543bb0784fbd8a79eb90acbba5c6cf369538ea8316e8ad9773"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@3"

  # Temporarily apply patch to not ignore our preferred destination directories
  # Remove for >=1.9
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/ssldump", "-v"
  end
end

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -8,6 +7,9 @@ project(
     LANGUAGES C
 )
 
+include(CheckSymbolExists)
+include(GNUInstallDirs)
+
 configure_file(base/pcap-snoop.c.in base/pcap-snoop.c)
 
 set(SOURCES
@@ -110,8 +112,5 @@ target_link_libraries(ssldump
         ${JSONC_LIBRARIES}
 )
 
-set(CMAKE_INSTALL_PREFIX "/usr/local")
-install(TARGETS ssldump DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
-
-set(CMAKE_INSTALL_MANDIR "/usr/local/share/man")
+install(TARGETS ssldump DESTINATION ${CMAKE_INSTALL_BINDIR})
 install(FILES ssldump.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
