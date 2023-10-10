require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.6.1.tgz"
  sha256 "9919f3f0e95cfddf5199c05f205ee94b4c17560e97ba697fbe5876e5d4a30b10"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "b90ecd011eccd906f66a13d226c94a028bf1080d1d4231464cb314f2854aeb1b"
    sha256                               arm64_ventura:  "cb281f44936df684cd15c018617ac03b9788c0d441ef245de3c1f07993e0066a"
    sha256                               arm64_monterey: "0f3cf2822702f2d059b4c520229ce9033eac3537178798af985de8d109728df1"
    sha256                               sonoma:         "63729fb1d80b2ca26289b01c1b8da2c9b047f6ddbd4423911cfaacc554414509"
    sha256                               ventura:        "67f7b3c985e2f6e523a472b9f5442254d5ade2a5d2fe52a517c802280d645b71"
    sha256                               monterey:       "15e00030aafca1a6cfd0264f04508201724bbfdfbeb0591c88457bd1f12a7bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304cdde76b18171838fdbbeb29592e40904e54f9462cb3f10bc778fa7748c42a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
