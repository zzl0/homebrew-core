class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  stable do
    url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.17.0.tar.gz"
    sha256 "f2820fa3be70d44f469b1ff7280e6517e17766e248fb117e5f5e5499cab20429"

    # Patch go1.21 build
    # Upstream PR ref, https://github.com/thomaspoignant/go-feature-flag/pull/1208
    patch do
      url "https://github.com/thomaspoignant/go-feature-flag/commit/dc834ae368b50280aebda88eb609b4a4bce084d6.patch?full_index=1"
      sha256 "64936b7b17c3730d6ca8e4946ceedbf574a9d23c5789692f5ee0b03437e43699"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1d70ac746d0cda9f175338c1e56211199ba5f246e3e9a94ffba26ed44a1e14b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe96ead5729677f4dc4ee9aaf687c291fabd59724ecab1af02600bcfdc3f95e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42732c3493bc4135d7140c2dd67b4539ac7f98c8c778a7764701f6ef6c597ec7"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd8464914c238432a9ea312d7d2e598d88c7ea3f24da0391ba1c1ee6293e314e"
    sha256 cellar: :any_skip_relocation, ventura:        "7333862396f230fbac3e85a37af3f814732bc4cf1c98744a991717ca35cb5f66"
    sha256 cellar: :any_skip_relocation, monterey:       "f356d25551470c6f85f70fdae763219ed6be1018010025ec2d4f98524aa34105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a1013c59521e9f33cf121cc4c96b63c4679d114d50c21e49ad8a6c98b50559e"
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
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
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
