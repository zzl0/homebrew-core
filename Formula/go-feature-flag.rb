class GoFeatureFlag < Formula
  desc "Simple, complete, and lightweight feature flag solution"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "ab69a45e57af57715d39d5c8534c58111e7f2be2c8a6b8628fadd7134b46bc1c"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ce78bd5c39daf0e83f16ed63bf36efa5add7e043533ee46352e8693bb271267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ce78bd5c39daf0e83f16ed63bf36efa5add7e043533ee46352e8693bb271267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ce78bd5c39daf0e83f16ed63bf36efa5add7e043533ee46352e8693bb271267"
    sha256 cellar: :any_skip_relocation, ventura:        "bb85a2881ef79b85775f61a73cb8b69a510639cf2e9eb78e812ac8a881e53614"
    sha256 cellar: :any_skip_relocation, monterey:       "bb85a2881ef79b85775f61a73cb8b69a510639cf2e9eb78e812ac8a881e53614"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb85a2881ef79b85775f61a73cb8b69a510639cf2e9eb78e812ac8a881e53614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4dad9394d0076c9f20e633c382223e23c7452d227240921c0beb122e7a6375e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
