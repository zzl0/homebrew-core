class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.3.0/libimobiledevice-1.3.0.tar.bz2"
  sha256 "53f2640c6365cd9f302a6248f531822dc94a6cced3f17128d4479a77bd75b0f6"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b0bc526c6c835d2520e0639f3d69878d36924ff027cdf37079b4e13c1c3c811"
    sha256 cellar: :any,                 arm64_monterey: "fbb4fb23c2748673e31c493b5e0cf96d95004e6ab5dd68be83a6544153499ba7"
    sha256 cellar: :any,                 arm64_big_sur:  "a65ec432835dd253158a5044dfd7fafaab256467973b8a01f066fd6e29cedba7"
    sha256 cellar: :any,                 ventura:        "9f4d061e7b5acbc2b923417015ace4bd8612a5c15da38e0499ae6835b449b890"
    sha256 cellar: :any,                 monterey:       "d896a569b513227dae0b0db4a2b2ae3117b1a7330be096bc9a2d791a925c232b"
    sha256 cellar: :any,                 big_sur:        "62ea023e2c7fa38577a731e0d19e97d7e0a109beb6da1ea9b1a3c5baee6f034e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb10c484ec49f216384ad7e80d309e026178359df395892b28400f24cb7fedf5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "libusbmuxd"
  depends_on "openssl@3"

  def install
    # Make libimobiledevice work with libplist 2.3.0
    # Remove this once libimobiledevice gets a new release
    inreplace "common/utils.h", "PLIST_FORMAT_XML", "PLIST_FORMAT_XML_" if build.stable?
    inreplace "common/utils.h", "PLIST_FORMAT_BINARY", "PLIST_FORMAT_BINARY_" if build.stable?

    # As long as libplist builds without Cython bindings,
    # so should libimobiledevice as well.
    args = %w[
      --disable-silent-rules
      --without-cython
      --enable-debug
    ]

    system "./autogen.sh", *std_configure_args, *args if build.head?
    system "./configure", *std_configure_args, *args if build.stable?
    system "make", "install"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end
