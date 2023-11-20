require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.5.2.tgz"
  sha256 "87e88b3a076365421c49fa44591b507c45c5d20a983ddeb4832d2fee8d18a4e4"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "415d025a57a5eae931e9d38a5b830095780c73a293d4f6c75a676d49f4a0f1c6"
    sha256                               arm64_ventura:  "7161e8a9019876962059b58d145ae053d850b7a028ce6da61868cb151a7aa531"
    sha256                               arm64_monterey: "f9677bb63031879a9ac9ee1f1d6757f3b263a543c58df5007d68806ce4f14aec"
    sha256                               sonoma:         "f7f6b3d10effc4836ee1fa5a764497732333de563c461aca6d447ed0884932c7"
    sha256                               ventura:        "89dc23792677de2e12fd534d1ff818c5490fda726b46ddc8c56e3227c2b339d4"
    sha256                               monterey:       "503b9b6a526b87fc7fdde55e4ffe8d18a1df87e5f2b929c6ed5d149ebcc6cadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6a36f664772ec4be4206a410794e5f52f866d817d0e737e400ba7767c27ca9"
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
