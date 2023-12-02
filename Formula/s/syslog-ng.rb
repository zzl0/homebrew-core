class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.5.0/syslog-ng-4.5.0.tar.gz"
  sha256 "08828ed200436c3ca4c98e5b74885440661c1036965e219aa9261b31a24fa144"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "823add8e8248ea4c2206a311797c0c887508828c2968b0b59e6b3ea1a3b49261"
    sha256 arm64_ventura:  "910f192f0e9e821da9502926c3a5af3982cad275dae6e90f20797768d064d383"
    sha256 arm64_monterey: "62a6a218f17b6195b839a080ed857fec3c6157e6ba823b7cf27facb7076327e5"
    sha256 sonoma:         "8d9464b1449917ae78b0c143a487519d9972a606d1093b79183fcdd6c323d466"
    sha256 ventura:        "06ff04bde3b5ef7cd30b484a2f1bde3d095919b9fe7e0ba6c10a25ff3db75844"
    sha256 monterey:       "5e458ac603e8caa85267e1e3bf520e4279e0f29dab83d5dedb3582361a3bb921"
    sha256 x86_64_linux:   "09513aa00e81b44f43418c5c411b775aea1dab17367042f92b84cef2e637f8f3"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "riemann-client"

  uses_from_macos "curl"

  # Clang c++ compilation fixes.
  # Remove when merged and released: https://github.com/syslog-ng/syslog-ng/pull/4739
  # See also: https://github.com/Homebrew/homebrew-core/pull/156185#issuecomment-1837419001
  patch do
    url "https://github.com/syslog-ng/syslog-ng/commit/27db599781eaf07ed6a93d96564df4e126dd1518.patch?full_index=1"
    sha256 "1f78793bb456d7ee7656116b2238ded280cf42ebb4b37b65de20cb26ba753041"
  end

  def install
    # In file included from /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/c++/v1/compare:157:
    # ./version:1:1: error: expected unqualified-id
    rm "VERSION"
    ENV["VERSION"] = version

    python3 = "python3.12"
    sng_python_ver = Language::Python.major_minor_version python3

    venv_path = libexec/"python-venv"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}/#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-afsnmp",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"

    requirements = lib/"syslog-ng/python/requirements.txt"
    venv = virtualenv_create(venv_path, python3)
    venv.pip_install requirements.read.gsub(/#.*$/, "")
    cp requirements, venv_path
  end

  test do
    assert_equal "syslog-ng #{version.major} (#{version})",
                 shell_output("#{sbin}/syslog-ng --version").lines.first.chomp
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
