class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.32.0/gpsim-0.32.1.tar.gz"
  sha256 "c704d923ae771fabb7f63775a564dfefd7018a79c914671c4477854420b32e69"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/gpsim[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma: "47237c675e0d58452a5af3af244b6184cadedb63301c838af1c37fadcf6acca3"
    sha256 cellar: :any,                 sonoma:       "f97272437dba25f87e9572fb5fb727340f6d07f2876133aa8628f8c3357447c5"
    sha256 cellar: :any,                 monterey:     "2e5195547b9d5783ed68956e0c158d0f9de968da495b0cecf18b76d787746638"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "edbf0180a035cb6d807a858c590176a01d169d0d0fe84dd6b24505ad05433b18"
  end

  depends_on "gputils" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"
  depends_on "readline"

  def install
    ENV.cxx11

    system "./configure", "--disable-gui",
                          "--disable-shared",
                          *std_configure_args
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/gpsim", "--version"
  end
end
