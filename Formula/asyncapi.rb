require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.52.0.tgz"
  sha256 "9f0c111ec2e883a7e6d86fe9f1ceb7500756ca10b8664828dfadbc8c4f6a5ee6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c430dab830852191c65cdf31ba6230c37e550d0ef780073b8e9b526c2c0a43c"
    sha256 cellar: :any,                 arm64_monterey: "6c430dab830852191c65cdf31ba6230c37e550d0ef780073b8e9b526c2c0a43c"
    sha256 cellar: :any,                 arm64_big_sur:  "6c430dab830852191c65cdf31ba6230c37e550d0ef780073b8e9b526c2c0a43c"
    sha256 cellar: :any,                 ventura:        "a1eacf304933bbfd8999df1205d03e020db87297d676c6b3429a674bbf5bf758"
    sha256 cellar: :any,                 monterey:       "a1eacf304933bbfd8999df1205d03e020db87297d676c6b3429a674bbf5bf758"
    sha256 cellar: :any,                 big_sur:        "a1eacf304933bbfd8999df1205d03e020db87297d676c6b3429a674bbf5bf758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ecde27a4ac7b59a60b16375518c2fee872fd2d79f77a68eef220761b04915a"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
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
