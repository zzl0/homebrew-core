class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.10.0.tar.gz"
  sha256 "9e6ddc0590e0ea431f3cc698ceb4acc082774ce67319136d9516e3389c2155ed"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72d53f97f27e81c7af8cbf42b55f787c789e47ed3ed0d475010910f347afb5e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11f2933b853836ffcbc0c956c7b875684881ac54be57655a76e5b2447a08ed83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bebb72b25442b69977b9b5b5dcb8eb766dc4a6faadbc4fd831756bf4ac275b3"
    sha256 cellar: :any_skip_relocation, ventura:        "5c53f837f28d1181503baff35437214968280ddd8406b1ab62060fefea8d5354"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7c1a43031f0e9775342991d4599f578c8a2a54021c9d27c0934cf74eeb0284"
    sha256 cellar: :any_skip_relocation, big_sur:        "a14f1b809ec2d453b89882ec914695fc272114e103fe6fd4015ad0ff296b0857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad71440ef06ae93517cd8b8ecbef68da143644e1aec8226bee37b4ea1367a758"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_predicate testpath/"log", :exist?
  end
end
