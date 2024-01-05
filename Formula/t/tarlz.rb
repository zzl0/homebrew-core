class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.25.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.25.tar.lz"
  sha256 "7d0bbe9c3a137bb93a10be56988fcf7362e4dbc65490639edc4255b704105fce"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8253224a69a54c9d86b7ce062a19a16202855672c321fe6637f3a2c4492f3844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c246f551b1b7aac697aa6fa07ef8cab03356dea54dffd2057ca72fce33b5b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9163497b962fdcc9f0d846d4529dd9e2467534760de8b09262488a0e7969d4f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "efb13a712648bee26fbda8e096c309bed4095bae3bc6de035993918f875f94f5"
    sha256 cellar: :any_skip_relocation, ventura:        "94b6ae7dabb81f2fb79a2a3263f419a69590ef889517a4c73f6f71b093a40e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "1003be058ef246a8db7fafadf561c706572304dc567680148ecb39f6f673b632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c437f5d15a94bb56857ae9687f2f530de669c41f3cb9aae69f6cec5878378fa1"
  end

  depends_on "lzlib"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    spath = testpath/"source"
    dpath = testpath/"destination"
    stestfilepath = spath/"test.txt"
    dtestfilepath = dpath/"source/test.txt"
    lzipfilepath = testpath/"test.tar.lz"
    stestfilepath.write "TEST CONTENT"

    mkdir_p spath
    mkdir_p dpath

    system bin/"tarlz", "-C", testpath, "-cf", lzipfilepath, "source"
    assert_predicate lzipfilepath, :exist?

    system "#{bin}/tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end
