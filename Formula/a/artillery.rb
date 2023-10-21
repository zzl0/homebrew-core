require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-38.tgz"
  sha256 "4b110c4eff35e3a786a88429beb05b9fd0f50eb22c045e687d10d9ea886dc86b"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "bbe2d126a575d870cbd0dc5ba61526d2f793385f975bca90ada8c524cc6fc69b"
    sha256                               arm64_monterey: "6d380ed2c8250cbf5db5151592d96cd88e4648fce5bd5aed623eb638ea0eb4e7"
    sha256                               arm64_big_sur:  "684cac3f7e4a734cf3c1a899b11e9479c91265dbe43c07ca98247a2b906ac605"
    sha256                               ventura:        "178ce66109510a171ec28c1df06c77adbd2347d1660013c7c91ca5a188b586af"
    sha256                               monterey:       "8029e4d469e72f924762fb805d5eb80f769bd4a523d9b34bad9378135879e46d"
    sha256                               big_sur:        "26d15be6be080ad17430a500438743609d43a54d112ecc0e125379433b686a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c25b4560193af9b3673c9d90b7e751dd27e633d26b55379d8dffe7504a4d02"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/artillery/node_modules/fsevents/fsevents.node"
  end

  test do
    system bin/"artillery", "dino", "-m", "let's run some tests!"

    (testpath/"config.yml").write <<~EOS
      config:
        target: "http://httpbin.org"
        phases:
          - duration: 10
            arrivalRate: 1
      scenarios:
        - flow:
            - get:
                url: "/headers"
            - post:
                url: "/response-headers"
    EOS

    assert_match "All VUs finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end
