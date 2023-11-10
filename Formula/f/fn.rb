class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.28.tar.gz"
  sha256 "15e300b06ff9555a8b4a32cc335d91b6165ef181fd0dd9bb098f47736647e17c"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64b00d2c6d61a663c424724cc7f2eda65bb093e1bbc412d32b6b92648dbc8955"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c99c23721ffa7049cbbc37a435e78f2ed30ac1599c91cf22f32aca603ab5c632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665633f0ee58202a8f6ec6bdfb79d7185818794b4c8a4dbaec35f823c5cafddb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d030f09f1ef095ff2653622f42196f2e5b6d6a1b699c989672825907b2eb6f5"
    sha256 cellar: :any_skip_relocation, ventura:        "fce9b0a3e76b959bf10bc929dc45a2d5b48e70a745d94ab4d1462702876a2647"
    sha256 cellar: :any_skip_relocation, monterey:       "d9f2cd7364677257f4320e8b8d2a96fed1eb0395a0ed9e2cec99bfd90fbfca0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b363cb1fc67e64361165fe51baff9fba9738f6edf47ec7ed26844630e7308fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        response = {
          id:         "01CQNY9PADNG8G00GZJ000000A",
          name:       "myapp",
          created_at: "2018-09-18T08:56:08.269Z",
          updated_at: "2018-09-18T08:56:08.269Z",
        }.to_json

        socket = server.accept
        socket.gets
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
