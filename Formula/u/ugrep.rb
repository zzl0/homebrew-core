class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "55cc44007fbc01fdb962e253ca58771b2d81570d990c4108d7e5c6fa86f6fae5"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "222b40439976d39c0733041e2f915fd5af043766b2923e2d98bc75aa5ad03c1e"
    sha256                               arm64_ventura:  "cd8c51e1ed66c3205a4fb99f107adb090577d042c6182e01a919c71f37e8c83d"
    sha256                               arm64_monterey: "30eb5e20d5871b0c37744c8224687c0a1293941ef20388b739f18bf8d9954536"
    sha256                               sonoma:         "f512b84f3750f6635d2d15b5f71b4f90c2ff0e4b3aca9950791f692bac466d1e"
    sha256                               ventura:        "8fa73204a725a9cd3a4998e85a5547ab5883fd0a008a7fa15ed0455e0ae0faf4"
    sha256                               monterey:       "06077f9b40f1da191529142d858efbd77a81192c7cbf4ec613c49446df5e2b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66da558194f1dbf204fa88a884d808f3c483903c8d164a8f857249be0ec4780"
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
