require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.4.3.tgz"
  sha256 "1e494eb2fa98b8b747cd7dc16df490d04d1e3f3fd8520507e98d4e2eabea2818"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59098998d8e2c7d6905c1132454d3f25b169427f678805031e0a740ab50b48ae"
    sha256 cellar: :any,                 arm64_ventura:  "59098998d8e2c7d6905c1132454d3f25b169427f678805031e0a740ab50b48ae"
    sha256 cellar: :any,                 arm64_monterey: "59098998d8e2c7d6905c1132454d3f25b169427f678805031e0a740ab50b48ae"
    sha256 cellar: :any,                 sonoma:         "03f9774f984f91223fba5b0b75725f265c4de1117e1395621fea91847362f515"
    sha256 cellar: :any,                 ventura:        "03f9774f984f91223fba5b0b75725f265c4de1117e1395621fea91847362f515"
    sha256 cellar: :any,                 monterey:       "03f9774f984f91223fba5b0b75725f265c4de1117e1395621fea91847362f515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c5bed0b56af621cddb648918073212d400ee3c7ed0ffb80bd4087e5ffcd6cb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
