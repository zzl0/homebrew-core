class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.8.0.tar.gz"
  sha256 "820da4e384721915f4bcaf7f2bed98519da563c6e4c130c742c724760ec02a0a"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ff51f5201d782f2efcd4e039afc434cf6594905834f43a36320093a2fd5482c7"
    sha256 arm64_ventura:  "09aa50e0ff6b9dcbc6457acce3242fa0f259534e45f45df1962f3a55a2f84b54"
    sha256 arm64_monterey: "aa66c94672a6831ba5845d0d9fe73021fe9ea21e1403d1f194222fbabd60c91e"
    sha256 arm64_big_sur:  "7d1a23581b87a516f4adab974626ceeed458342a2177c6870686160c8edc7efa"
    sha256 sonoma:         "aea4cc65e0c7088ec82417cc81e55fa3e925a7785fef8b11209441669e677453"
    sha256 ventura:        "0f2566019b7601c94d0f21ab7854025eb5c1f5c843bcf429c72fb7501d4f62fa"
    sha256 monterey:       "39d73cf7533e96c0c1434baa1f59211e4be2b4ceeb176fa04b44e05b66206dca"
    sha256 big_sur:        "1f146848df2780720ea966f52f6f48e3c428c5400ce0cec2216b76b9166f50c7"
    sha256 x86_64_linux:   "cdb25f1576f8f2e074781348b7754d039943e472cf72c464f7497d8b4ef41281"
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
