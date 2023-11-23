require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.1.3.tgz"
  sha256 "4e55ea51a38fd76fe3748a9585de97f0e1fb43145d70efae054798faae4317f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b9576bd9ec26152ec6ade48f3ded8c6d7cff3d01288d1223486f689435e671a7"
    sha256 cellar: :any,                 arm64_ventura:  "b9576bd9ec26152ec6ade48f3ded8c6d7cff3d01288d1223486f689435e671a7"
    sha256 cellar: :any,                 arm64_monterey: "b9576bd9ec26152ec6ade48f3ded8c6d7cff3d01288d1223486f689435e671a7"
    sha256 cellar: :any,                 sonoma:         "120fde301adc31bd2f127fb6d804465850570be608d6026f5bc4db295a7852b7"
    sha256 cellar: :any,                 ventura:        "120fde301adc31bd2f127fb6d804465850570be608d6026f5bc4db295a7852b7"
    sha256 cellar: :any,                 monterey:       "120fde301adc31bd2f127fb6d804465850570be608d6026f5bc4db295a7852b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039d98327a6cd81b8f9ce73ae4d1d16c6ff383d90d66e26b01eecc7ad52c9fa9"
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
