class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "81b4854b6a8bd69ff3bac616a8e5363bd020224161fa0a1af3c63da0e7a07150"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "a9a15764049203466cb3baed0119944d42b66a3b6fdd34d56fd559e2ee424f4f"
    sha256                               arm64_ventura:  "bf6a46d02dfff7dd03915e14cf041e902916bd23f28b7256638f233656901554"
    sha256                               arm64_monterey: "ca693b15e5792179ff14bb538b2d92d49ff400a34cfeb1fb066cf0b9871010ae"
    sha256                               sonoma:         "44bcb29b4e3c5aca63f6c471550353b79b84cf2c850fb7fd0f0c5ce80b306d38"
    sha256                               ventura:        "8c72f65ae8f7f5f47f1df159241a9a2dc706afeb70e8354fdced5c8e5c043e0d"
    sha256                               monterey:       "9b77002d4005aa82e36d5896d9bd45e3c041ee44dc3ea9d2edc0fa96aca861a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c8dab059ec38f97afd9d5c87fd01545712f5fc5b0e252f4419313afa700f19"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

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
