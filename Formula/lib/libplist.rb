class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/releases/download/2.3.0/libplist-2.3.0.tar.bz2"
  sha256 "4e8580d3f39d3dfa13cefab1a13f39ea85c4b0202e9305c5c8f63818182cac61"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libplist.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01262690c3dea33ba8d621b5f9e748c84f7e38a3b6648425bf5a97493a9d3ccf"
    sha256 cellar: :any,                 arm64_ventura:  "6d101d1a75fe2859fce732e1a9448053c74707a3cdc7e10e4b67488d978b0796"
    sha256 cellar: :any,                 arm64_monterey: "b31c287f7c027c0f241dbfecb261e2a71910dcff601ceb5404ec8072dfd2a453"
    sha256 cellar: :any,                 arm64_big_sur:  "ed9c2d665d5700c91f099bd433a38ba904b63eef4d3cdc47bd0f6b0229ac689a"
    sha256 cellar: :any,                 sonoma:         "14142fc189e6a7252f33178270df4f7480ea41ea3d9e802332eb84d6c2d4ad74"
    sha256 cellar: :any,                 ventura:        "df3e285aa4d7ce69059bf1609fa5d2a442e0c1434e478e5603567702d3e38760"
    sha256 cellar: :any,                 monterey:       "fd33860939e18cc5a5c50be2ca667db7d99a191aa445fefdfde51435c0f4453d"
    sha256 cellar: :any,                 big_sur:        "1ac05ef69cc02f4663fbb1c3d6d6e964c70a5ba0743d7e9e242da06864a63a70"
    sha256 cellar: :any,                 catalina:       "20faf60d286c8ceed790a9b6e34245acf7bafacc7fcbcb390d6b62e194b323e6"
    sha256 cellar: :any,                 mojave:         "768453f8710ec1c3e074ad0ebc7723da88c2b8575e5de6962ca6f1d4a85cb61d"
    sha256 cellar: :any,                 high_sierra:    "02291f2f28099a73de8fa37b49962fe575a434be63af356cceff9200c6d73f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6677078ae6fbcfeabfee04dcb64e405f1bfcea07643752e3b5db89780404d5e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %w[
      --disable-silent-rules
      --without-cython
    ]

    system "./autogen.sh", *std_configure_args, *args if build.head?
    system "./configure", *std_configure_args, *args if build.stable?
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>test</string>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/echo</string>
        </array>
      </dict>
      </plist>
    EOS
    system bin/"plistutil", "-i", "test.plist", "-o", "test_binary.plist"
    assert_predicate testpath/"test_binary.plist", :exist?,
                     "Failed to create converted plist!"
  end
end
