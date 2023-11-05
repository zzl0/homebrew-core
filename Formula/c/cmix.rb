class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/refs/tags/v20.tar.gz"
  sha256 "a95b0d7430d61b558731e7627f41e170cb7802d1a8a862f38628f8d921dc61b2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "33f11449a68550e6fbdfdbcf60b275e6e55c3e9c6121df84544bc101c95fee65"
    sha256 cellar: :any_skip_relocation, ventura:      "40bf530791b86dbc0f59f6d1a5aa35780756e7afd5a0f13030d8bdec8c9bc1bf"
    sha256 cellar: :any_skip_relocation, monterey:     "9c2261847967e7814706d5c24cec9fb575a454f011e85202f09821e4eca2007a"
    sha256 cellar: :any_skip_relocation, big_sur:      "a0828549c71f1af934ad53a31c7b291c397eb9fd77e158d2634e32fafe1e8e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "578fa48d0405fde362bcab38eaead31a8bcf4330d81806119e82824d02b08ef1"
  end

  def install
    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/cmix", "-c", "foo", "foo.cmix"
    system "#{bin}/cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
