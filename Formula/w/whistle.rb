require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.62.tgz"
  sha256 "0648c8b532c901a552075fde751714837564ec6a5b556fff96285ff1ea03a70d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ab2da578dd75f849cee454577217d75c3c7c645f0b2121876d2f96e7974f24c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ab2da578dd75f849cee454577217d75c3c7c645f0b2121876d2f96e7974f24c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ab2da578dd75f849cee454577217d75c3c7c645f0b2121876d2f96e7974f24c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9145f134f9318880112bbac43457eaf3dd3dd719f4e46449d4dedd83a6725c90"
    sha256 cellar: :any_skip_relocation, ventura:        "9145f134f9318880112bbac43457eaf3dd3dd719f4e46449d4dedd83a6725c90"
    sha256 cellar: :any_skip_relocation, monterey:       "9145f134f9318880112bbac43457eaf3dd3dd719f4e46449d4dedd83a6725c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9145f134f9318880112bbac43457eaf3dd3dd719f4e46449d4dedd83a6725c90"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
