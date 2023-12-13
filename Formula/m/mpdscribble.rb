class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://www.musicpd.org/clients/mpdscribble/"
  url "https://www.musicpd.org/download/mpdscribble/0.25/mpdscribble-0.25.tar.xz"
  sha256 "20f89d945bf517c4d68bf77a77a359fdb13842ab1295e8d21eda79be2b5b35ce"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mpdscribble[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cd779e47e8c11d9ab3d2dc0f16af582c2d48fddc55a8ae329457a9cbd1c0e28d"
    sha256 arm64_ventura:  "ae57ca49a553d9b3c52d221c988fd7db50cb2b73a6bfa8770f40afe2072b7818"
    sha256 arm64_monterey: "101f7677113534f4432b89ff1ca9cd9a9677a1ca15697cf876b7c430c6883b23"
    sha256 arm64_big_sur:  "c473ded7b091401379daf8b14d076c7e4ea835e0da5915f689c10482e413fc55"
    sha256 sonoma:         "e56cf7a89a42a53e5d02dc46cea831e44bdeb7c318181b576cacced4d9431ce7"
    sha256 ventura:        "382070590073cb7a59e5ba786eb506a735ef2989b0351ebb9c620b555a967954"
    sha256 monterey:       "7c8ac2c91c994368d5978770ceeb9f63960bec3b043b4b22538804268f1c0db8"
    sha256 big_sur:        "fbd81b4642294a6d2362ee03d17315d20c3aefc8aa07731bc9ff01cf9134be96"
    sha256 catalina:       "82a9465072feede3c7e85f39253901d2eaf2342bdff720ce0c0cf1245e9fafa8"
    sha256 x86_64_linux:   "bfec788d81176ae3f6e668a741b95db6ed9765c1a27d07504e4e120538fe3df5"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libmpdclient"

  uses_from_macos "curl"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "--sysconfdir=#{etc}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    <<~EOS
      The configuration file has been placed in #{etc}/mpdscribble.conf.
    EOS
  end

  service do
    run [opt_bin/"mpdscribble", "--no-daemon"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/mpdscribble", "--version"
  end
end
