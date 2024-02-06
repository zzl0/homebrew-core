class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://github.com/chaos/powerman"
  url "https://github.com/chaos/powerman/releases/download/v2.4.0/powerman-2.4.0.tar.gz"
  sha256 "ff5f66285e1d952b4dbcb9543ef7969bb4abb464276aaecff949f629b72da605"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "fd35a442ecd342e00a4c09e0c29f49eefea4b07e08756742ab5af006dbc77a29"
    sha256 arm64_ventura:  "111132a22f3537ebc1726cec49965768bc874fabaf46b2c2c7e5c1dfe7bd6c1c"
    sha256 arm64_monterey: "bf7397842c0e10d990a848340dfb2287596ed94591840997a946886edfb307d9"
    sha256 arm64_big_sur:  "9742622a1433440ff96eb624c08a9b28c30fa12d4d120bc3d73072acc371a968"
    sha256 sonoma:         "6652f45479868d7d41e481ab3a37c76caa95d254a89a3697f95ee66f11fc8e47"
    sha256 ventura:        "07d0663bbe475dbe29617e4a7678ca4a6076303da2c1553a8fc2ca411ac0b575"
    sha256 monterey:       "518f201a1163ea0c947a9322360f7020f45f5d115752b06497baadbe0cc3f987"
    sha256 big_sur:        "a493a8832e7af6dce239bdea4db718455d5d919c39ff3fc027a5b7192f0416f4"
    sha256 catalina:       "a453e51a5217c9bb4846590f195710c693aa38382ea78b14750437a3fba53784"
    sha256 x86_64_linux:   "15e926da608bdb3d7aa8ddd394f85608cd7effaa775df653059a5ed6c4809f32"
  end

  head do
    url "https://github.com/chaos/powerman.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers"
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
