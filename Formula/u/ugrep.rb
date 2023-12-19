class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "5b8a08743bbf5c8b9d4719211961b8fb427988ffcada6d8c57dfaed9b6d12f7e"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "eec34db8c8aa55fe686e047587741777586d8be5c375142ef69b0da0f9899893"
    sha256                               arm64_ventura:  "df7a43742dd1763f4ba0993aebd01d700ec6bb8ed0d0dc03892d652a4147b720"
    sha256                               arm64_monterey: "f4f5ca66e406cf3df1581a43159ac595f6f0c57d0a5c9ac4d453e7c5d14bba50"
    sha256                               sonoma:         "06c3f71c9d25d018d33e8289e103311b732e8c1eaaed750ad715aee20ef6f25a"
    sha256                               ventura:        "f372513af217cd09ed24046d128821bd10dc54b86116399c27fcb759dcb6aae3"
    sha256                               monterey:       "161850de9bc7306758d7b9b47f684d2ff1d769e036eb3c37b36ded1254030815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7e80a2d87b30b9542cf6fdaec9f95ec6a904e9a52512c57cdd83607acc4f52"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
