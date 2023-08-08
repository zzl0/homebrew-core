require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.0.tgz"
  sha256 "804450dc9a0c19bf02d46c47223dbc147661afe73ce5910eab77d35a527a19ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c5215135362198bf70e540fcdf535eb785a0e5e68ebc28d8948743dc4a48367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5215135362198bf70e540fcdf535eb785a0e5e68ebc28d8948743dc4a48367"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c5215135362198bf70e540fcdf535eb785a0e5e68ebc28d8948743dc4a48367"
    sha256 cellar: :any_skip_relocation, ventura:        "fa6986a81b03c8371ba02cb42461c1e87ba2f5fd9874685e8d6740bb9399cf0a"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6986a81b03c8371ba02cb42461c1e87ba2f5fd9874685e8d6740bb9399cf0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa6986a81b03c8371ba02cb42461c1e87ba2f5fd9874685e8d6740bb9399cf0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b61a389b91f1f290e9aaa347ee57ab48340ab9d7059d09b8b0d11670f98d13c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
