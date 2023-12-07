class OpenSimh < Formula
  desc "Multi-system computer simulator"
  homepage "https://opensimh.org/"
  url "https://github.com/open-simh/simh/archive/refs/tags/v3.12-3.tar.gz"
  sha256 "9d0370c79e8910fa1cd2b19d23885bfaa5564df86101c40481dd9b6e64593b18"
  license "MIT"
  head "https://github.com/open-simh/simh.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-\d+)?)$/i)
  end

  depends_on "libpng"
  depends_on "pcre"
  depends_on "vde"

  uses_from_macos "libedit"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  def install
    ENV.append_to_cflags "-Os -fcommon" if OS.linux?
    inreplace "makefile" do |s|
      s.gsub! "+= /usr/lib/", "+= /usr/lib/ #{HOMEBREW_PREFIX}/lib/" if OS.linux?
      s.gsub! "GCC = gcc", "GCC = #{ENV.cc}"
      s.gsub! "= -O2", "= #{ENV.cflags}"
    end
    system "make", "all"

    bin.install Dir["BIN/*"]
    doc.install Dir["doc/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (pkgshare/"vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
