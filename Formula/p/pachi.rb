class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/refs/tags/pachi-12.84.tar.gz"
  sha256 "5ced9ffd9fdb0ee4cdb24ad341abbcb7df0ab8a7f244932b7dd3bfa0ff6180ba"
  license "GPL-2.0-only"
  head "https://github.com/pasky/pachi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc36b13c20604b90c51740831cce9701470241754f2b1e1376cf3b59d7013a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d25307a303833c144652b596baac8346e8274ed1669c5710f77675d978670692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c38b47dfb6e9f48507f47be141963ea5fb4b6329a83f015f4bd0d52c09325408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71f7bf11f6d68a8768468e4494cdc0785f484a5ccd7713cfc4327f049e79e80a"
    sha256 cellar: :any_skip_relocation, sonoma:         "875a4356ea6a4746457358ad77a03c620a720eeb84c77bcd10b33b192577906f"
    sha256 cellar: :any_skip_relocation, ventura:        "10306782a64e73d770c861e44c616a13cd417df1c346195f42426f62db6c1ec6"
    sha256 cellar: :any_skip_relocation, monterey:       "7079a129c324c7411aabe2c5357f3b5c86658bcec6b897f06e8cccf02e775a23"
    sha256 cellar: :any_skip_relocation, big_sur:        "d14dec70d5fedd0d7ba63b05f175b06b12c40e1da71d24da64712ce63858dae1"
    sha256 cellar: :any_skip_relocation, catalina:       "9a2adc64bf7dbfbaf9e3d9ff940d6c5bcb0e4040160ed62f57751ec87281132e"
    sha256 cellar: :any_skip_relocation, mojave:         "c88f24dd1e7a267848eab540dc2b0961962825ab6e7088fc24b335159dacf31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0fc26989c0cf90b6fa2256e129b0b87993464ec27ad88fefe569abdd9702292"
  end

  resource "datafiles" do
    url "https://github.com/pasky/pachi/releases/download/pachi-12.84/pachi-12.84-linux-static.tgz", using: :nounzip
    sha256 "c9b080a93468cb4eacfb6cb43ccd3c6ca2caacc784b02ebe5ec7ba3e4e071922"
  end

  def install
    ENV["MAC"] = "1" if OS.mac?
    ENV["GENERIC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"

    # https://github.com/pasky/pachi/issues/78
    inreplace "Makefile" do |s|
      unless build.head?
        s.gsub! "build.h: build.h.git", "build.h:"
        s.gsub! "@cp build.h.git", "echo '#define PACHI_GIT_BRANCH \"\"\\n#define PACHI_GIT_HASH \"\"' >>"
      end
      s.change_make_var! "DCNN", "0"
      s.change_make_var! "PREFIX", prefix
    end

    # Manually extract data files from Linux build, which is actually a zip file
    system "unzip", "-oj", resource("datafiles").cached_download, "*/*", "-x", "*/*/*", "-d", buildpath
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/^= [A-T][0-9]+$/, pipe_output("#{bin}/pachi", "genmove b\n", 0))
  end
end
