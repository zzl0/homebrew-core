require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.61.tgz"
  sha256 "f883fbbb41b05cf1b667dd24cb8560ffa603665fa0a1c58a1fc1b582eed62b0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "520b483f0020f95601708203b1bbf7d0971a0dc96be3c84ef778de9ebd7d1d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "520b483f0020f95601708203b1bbf7d0971a0dc96be3c84ef778de9ebd7d1d15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "520b483f0020f95601708203b1bbf7d0971a0dc96be3c84ef778de9ebd7d1d15"
    sha256 cellar: :any_skip_relocation, sonoma:         "04e9618796903894e0ce4d4b2fdaf41121ea9701aa8c9817e9128528762c86e7"
    sha256 cellar: :any_skip_relocation, ventura:        "04e9618796903894e0ce4d4b2fdaf41121ea9701aa8c9817e9128528762c86e7"
    sha256 cellar: :any_skip_relocation, monterey:       "04e9618796903894e0ce4d4b2fdaf41121ea9701aa8c9817e9128528762c86e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e9618796903894e0ce4d4b2fdaf41121ea9701aa8c9817e9128528762c86e7"
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
