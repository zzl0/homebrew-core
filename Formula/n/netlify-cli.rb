require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.13.0.tgz"
  sha256 "74ba180f24c3fb29a37a58a5beb8247c17104cad5e3abac8cac18c4be8430fb9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "17d03c49330d533ffe08008fe7843af5125cdc402f5023187b85f8287f0cb544"
    sha256                               arm64_ventura:  "069cce4ca7f03c2dc0da6892f927b0fedd358b4a7e4f7e159fb5df73c9563875"
    sha256                               arm64_monterey: "de7e3cf2718d5dc12a3d3e1431c51b5d9b5393619d7bc862a0b47623214864f8"
    sha256                               sonoma:         "0f02f18f66deb80d26bded992cfe77f3a66c77461b78fc2c36e08751b560fb57"
    sha256                               ventura:        "aca7b2fe4d7dc926ae46d8f9f589502c87ba2501a157fc463758a1596f148089"
    sha256                               monterey:       "ecf17e5fd992bb94dc522e356a308d1ec9484d2af320551a27da57e51daa2b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7517c5cbfc88bcd0d22f83365e5d020119516d944d72cafc7fbe03cc13a835f"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@parcel/watcher-linux-x64-musl/watcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
