require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.0.tgz"
  sha256 "de76095362f298ac15399cea3af028b6cdee5886bfcec13be21adebe5b2cf535"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfe193c6c09471959b2b8b8e9860c6e4f91bcacbea5134490eda7e48fe49afef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfe193c6c09471959b2b8b8e9860c6e4f91bcacbea5134490eda7e48fe49afef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe193c6c09471959b2b8b8e9860c6e4f91bcacbea5134490eda7e48fe49afef"
    sha256 cellar: :any_skip_relocation, sonoma:         "9857afe30fb99aa77e2873c4cd0649820b4fc7ee94fba6a8081416df5e51a2b6"
    sha256 cellar: :any_skip_relocation, ventura:        "9857afe30fb99aa77e2873c4cd0649820b4fc7ee94fba6a8081416df5e51a2b6"
    sha256 cellar: :any_skip_relocation, monterey:       "9857afe30fb99aa77e2873c4cd0649820b4fc7ee94fba6a8081416df5e51a2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e9a339af553788633b2b9ab57b9ad8784b3905d99e9b86a63c14123e1f7a1d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/vite/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    port = free_port
    output = ""
    PTY.spawn("#{bin}/vite preview --debug --port #{port}") do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("no config file found", output)
    assert_match("using resolved config", output)
  end
end
