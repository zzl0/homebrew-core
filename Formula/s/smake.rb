class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://s-make.sourceforge.net/"
  url "https://codeberg.org/schilytools/schilytools/archive/2023-04-19.tar.gz"
  version "1.7-2023-04-19"
  sha256 "a4270cdcca5dd69c0114079277b06e5efad260b0a099c9c09d31e16e99a23ff5"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_ventura:  "3ba94034a2afbc1b5ecb9e9fc016bbd082731977487e6dd0f33cfe8b4e572964"
    sha256 arm64_monterey: "2d5169eeee1297a1def9e51c0fcc0955a3ccd910bf4eff43ae78f514c52a6a29"
    sha256 arm64_big_sur:  "43034c1f8106c8f34f94e6ffbfc143521f1688929227b28a0c2c35d15a36e1a2"
    sha256 sonoma:         "f8dee9bd3e9d9d675fa756fea428c9de6d5b9382c8620281c3b943e45fd3600c"
    sha256 ventura:        "127941112a838979063acfb59e2c5352d0cc037b609dfc99acde2ff77275014a"
    sha256 monterey:       "52d900209f60d961485e6c2fe1c09c21f88d2a7f3cecd5340570ea876c7bfb01"
    sha256 big_sur:        "91320cb3802a9b395c25e93efc7162ebdf59514ec70fe82a7476b045120d7adc"
    sha256 catalina:       "c09f4bc9cdcaa26dddc33ec021083885ed7d9236b2af2c87713446ad1a0cb538"
    sha256 mojave:         "6dd776264c5583a982b9a8270956c84274387719aeae7b057d7c581ebc438c70"
    sha256 high_sierra:    "5b1860ab709b7a27201f781f31a34ccf6db6da600ef60741fd918a95c3beedb7"
    sha256 sierra:         "b1afe84c5a7b535738d2b2ee3f2abf879c908cf4f3b9c5a6f9f9cdd3fc403536"
    sha256 el_capitan:     "a5cb6ea4fab2d0ce67342f482fd0efb4dcc20483722e56ae120880d2a97ebab0"
    sha256 x86_64_linux:   "5d03986ec19a639fd339db5cb01fb7d1e11dbea580614a3ff70a24e1151feb24"
  end

  def install
    cd "psmake" do
      system "./MAKE-all"
    end

    cd "libschily" do
      system "../psmake/smake"
    end

    cd "smake" do
      system "../psmake/smake"
    end

    cd "man" do
      system "../psmake/smake"
    end

    bin.install Dir.glob("smake/OBJ/*/smake")
    man1.install Dir.glob("smake/OBJ/*/*/*.1")
    man5.install Dir.glob("man/man5/OBJ/*/*/*.5")
  end

  test do
    system "#{bin}/smake", "-version"
  end
end
