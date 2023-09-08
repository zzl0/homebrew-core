class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/SpiderLabs/ModSecurity"
  url "https://github.com/SpiderLabs/ModSecurity/releases/download/v3.0.10/modsecurity-v3.0.10.tar.gz"
  sha256 "d5d459f7c2e57a69a405f3222d8e285de419a594b0ea8829058709962227ead0"
  license "Apache-2.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "geoip"
  depends_on "libmaxminddb"
  depends_on "lua"
  depends_on "pcre2"
  depends_on "yajl"

  uses_from_macos "curl", since: :monterey
  uses_from_macos "libxml2"

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    libxml2 = "#{MacOS.sdk_path_if_needed}/usr"
    libxml2 = Formula["libxml2"].opt_prefix if OS.linux?

    args = [
      "--disable-debug-logs",
      "--disable-doxygen-html",
      "--disable-examples",
      "--with-libxml=#{libxml2}",
      "--with-lua=#{Formula["lua"].opt_prefix}",
      "--with-pcre2=#{Formula["pcre2"].opt_prefix}",
      "--with-yajl=#{Formula["yajl"].opt_prefix}",
    ]

    system "./configure", *args, *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/modsec-rules-check \"SecAuditEngine RelevantOnly\"")
    assert_match("Test ok", output)
  end
end
