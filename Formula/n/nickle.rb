class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.93.tar.xz"
  sha256 "a8dafb5f3e42528c212046a24559cbdbcb5d197c71b24f3e61543b85d3842beb"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6b74586d69fb295209f1e134497730201e7ca406d2aaaa4b0fa9ce385bc4a952"
    sha256 arm64_monterey: "3473cad84ef0de455ec96344c7e66da0960f30c6563342beee8f0d6bf2a36ff4"
    sha256 arm64_big_sur:  "d1a703115d1003e20de3f2573018441c14037997ae3d131a0b0e67736f29548b"
    sha256 ventura:        "ed7c59237f0f8d62ad817e39467b52a38c8616d4cb9e95864b19b0d4c511044a"
    sha256 monterey:       "d39add4399034b3c4e8aa4bcd06d62374b37c4347a816c65035dbc0f05e38ebd"
    sha256 big_sur:        "4d34984970372d1c8ce3b450628f01f06b58b66d6c84e6cf5f0d86f4c3b7bfcf"
    sha256 x86_64_linux:   "2526e64a0645e1fa72221049f6f1a27488f8066490966cb0f5237f6352bbab17"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    ENV["CC_FOR_BUILD"] = ENV.cc
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
