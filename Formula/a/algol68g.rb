class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.1.tar.gz"
  sha256 "30c3d5d641437e8956f174d4b37386bb007799ca4cf709e27cabf447610bce30"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57319e4096be80071b6bf179ad10b6b38881264c2b00fd7832b5c0cac3dddfa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e735c0c33c8efd43e95eb0d5db4d3d36400cedbbf201c48c45d3283dab4c9d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8cd5f28e938b3099b2472bfb4adbd209f2532fb1441cf7f86eb67213ff0cc9b"
    sha256                               ventura:        "cd19fa7326fbf06a7be203561db19bfc3de670cfd71a773cef3cbaf69275cb84"
    sha256                               monterey:       "53af4bae8c50465f1ca23e8f4af3d633d5e82ad13618df7cc0b014e0e09fb137"
    sha256                               big_sur:        "b4b665780ea1c1c0a82e0627bb2e1094235f589b78f8d1e674b81735704d7619"
    sha256                               x86_64_linux:   "4d4e99cddda469d93cac625eb6cc963ee53af978ff2689bb0d23ca81c1118156"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
