class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/4.3.1.tar.gz"
  sha256 "9a0044eb7c940dc8dba42de90439386929926b83f821b916db03bc308fdaf189"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "557d7e53af59825f71c9854ae30bcff7a564b61694ac22490d36ae5f97cb0052"
    sha256 arm64_monterey: "be5dcf43197f7273a776ca089b8e19e2e15f2113eb30417e86cc58a040dabaab"
    sha256 arm64_big_sur:  "b089212d4d835f1c5a5aeb0b899a55e1fce6d86dacd7c9717ebc9c34d4940712"
    sha256 ventura:        "8bed261f1e43bdb2278b490b8349945f3426bb16d8aa7fd38cbf05752be36374"
    sha256 monterey:       "07561e5d96c41b20e1b607cbf57d2932c83ef531b025765bc649ee3a7cce4090"
    sha256 big_sur:        "2c3bd6fa8dfbca7a303fd9e960a23e401ecc640069d8ed827ffaade3d542576a"
    sha256 x86_64_linux:   "fb40d633dc925b198da26961e76d67d495ff9a1f14d0de71c63ac474ba4c55da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pa
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  service do
    run [opt_bin/"shairport-sync", "--use-stderr", "--verbose"]
    keep_alive true
    log_path var/"log/shairport-sync.log"
    error_log_path var/"log/shairport-sync.log"
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end
