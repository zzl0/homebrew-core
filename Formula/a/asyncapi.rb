require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.59.0.tgz"
  sha256 "af13eff89f79969b66e09e30a06c71245ecbf75064cd75af8aa393c5917b7065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcf55f9f738f0746afa711a27d5db6613a999ccbf433e4326c354423a6d29060"
    sha256 cellar: :any,                 arm64_ventura:  "fcf55f9f738f0746afa711a27d5db6613a999ccbf433e4326c354423a6d29060"
    sha256 cellar: :any,                 arm64_monterey: "fcf55f9f738f0746afa711a27d5db6613a999ccbf433e4326c354423a6d29060"
    sha256 cellar: :any,                 sonoma:         "fe41b57ea407b95b15f13754d4b4519ded80243ca57e90ae75747bcad3881531"
    sha256 cellar: :any,                 ventura:        "fe41b57ea407b95b15f13754d4b4519ded80243ca57e90ae75747bcad3881531"
    sha256 cellar: :any,                 monterey:       "fe41b57ea407b95b15f13754d4b4519ded80243ca57e90ae75747bcad3881531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc1c3cd99c47be191ea7c21678fbc20ba23dfc91702efa1fd390b084bcf8102"
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
