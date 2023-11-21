require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.1.tgz"
  sha256 "1e64237bd3f9784b6884368f130efdda09e52d7a665506ee1a70dbae9dd71eb9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26e1de20f23a252f491ead909f41b099a43b0cf72c297c615280edf20c68ce06"
    sha256 cellar: :any,                 arm64_ventura:  "26e1de20f23a252f491ead909f41b099a43b0cf72c297c615280edf20c68ce06"
    sha256 cellar: :any,                 arm64_monterey: "26e1de20f23a252f491ead909f41b099a43b0cf72c297c615280edf20c68ce06"
    sha256 cellar: :any,                 sonoma:         "34b401be2d4a60491820bccf7a8c5af194e218522b826ccc14bbed84365d782d"
    sha256 cellar: :any,                 ventura:        "34b401be2d4a60491820bccf7a8c5af194e218522b826ccc14bbed84365d782d"
    sha256 cellar: :any,                 monterey:       "34b401be2d4a60491820bccf7a8c5af194e218522b826ccc14bbed84365d782d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "804fc1e155b756bb6939d98913f3490fe607489584ac62efec46c10a1a9035ce"
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
