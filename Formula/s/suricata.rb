class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.2.tar.gz"
  sha256 "b4eb604838ef99a8396bc8b7bb54cad11f2442cbd7cbb300e7f5aab19097bc4d"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "d1418153058ce8bedddcae8b4041e05f857a0765776e96dce2c017b57fcc2570"
    sha256 arm64_ventura:  "aa912ea10befe1a686256b8288806c0545cf283d0f078f5ed17be8625c6bee1d"
    sha256 arm64_monterey: "c13e5c49a85e5cfb9c2dd04fa21a2c0c7bb5f06561a466680bb3ac8e5b6dbad8"
    sha256 sonoma:         "2a11a7af7b533becd033d2146dae5ecd6a2acd3cd195ebe9ff31d5067d3486ae"
    sha256 ventura:        "f5f2adb3d9a7843e96a8679293a8ba952de3c3b834842f92b752ed6c098b96db"
    sha256 monterey:       "95c796fc3ff0c7b86e1f1e3a2e241265885399446324e043b6cf5e429890dc21"
    sha256 x86_64_linux:   "3289591e10a9ee0dd361333d788db3886e55485120815cb077aa424d8fb6e3f4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "pyyaml"

  uses_from_macos "libpcap"

  def install
    jansson = Formula["jansson"]
    libmagic = Formula["libmagic"]
    libnet = Formula["libnet"]

    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libjansson-includes=#{jansson.opt_include}
      --with-libjansson-libraries=#{jansson.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libraries=#{libnet.opt_lib}
    ]

    if OS.mac?
      args << "--enable-ipfw"
      # Workaround for dyld[98347]: symbol not found in flat namespace '_iconv'
      ENV.append "LIBS", "-liconv" if MacOS.version >= :monterey
    else
      args << "--with-libpcap-includes=#{Formula["libpcap"].opt_include}"
      args << "--with-libpcap-libraries=#{Formula["libpcap"].opt_lib}"
    end

    inreplace "configure", "for ac_prog in python3 ", "for ac_prog in python3.12 "
    system "./configure", *std_configure_args, *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: lib/"suricata/python")

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/suricata --build-info")
    assert_match "Found Suricata", shell_output("#{bin}/suricata-update list-sources")
  end
end
