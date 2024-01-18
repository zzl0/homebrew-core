require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.14.1.tgz"
  sha256 "7274b4ba1bc454c66afa0ef2aea368466d54883a356326da02f0a609130e2ab1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "57100308381e202fabc76e460c337e91329808356acc51b0c775f22dd6f7e0df"
    sha256                               arm64_ventura:  "4b15f350769fafe9beaba48407bf830130737a20eb20e215ff8991be724545b8"
    sha256                               arm64_monterey: "e0f253185442a5d0f15638b14fc686f22d708187f6df5010042f802e31bbcd15"
    sha256                               sonoma:         "5ce215d6bf33270733caed70d3ad5eab37f32a88fc2a1aaecbd6f238e6f00337"
    sha256                               ventura:        "5ded2baf6b0dc61cc13b6a8f799cfcb49de4b19205fed6b638fdccdb174db72b"
    sha256                               monterey:       "e69d6a704e9bc9763608be5d321c171c116a8cb02c98d6b318594791800236c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de69ed1e1b571590b076d0f8324d8347eb5b0b51339302c16d612def42d6075c"
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
