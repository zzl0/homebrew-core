class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.5",
      revision: "cecf83141e3813ad7e268521e6a95efce61cb146"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1695e818b74f214a40e1ddee74fbaaf53d5d971b0d01dae206697afcc0b2c822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20eaeb4a7ee01ab5ccbe388832b6018a47a19375339c11336fdea9519f46e7a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1276bd37c60b1532d0e9054bcb08f5f878bd25faf39a2d6bbc0da094143ec751"
    sha256 cellar: :any_skip_relocation, sonoma:         "03d6bd11ba68724cb9ab6c662c5b6d9017df7fdfc873a68b54d2ede224ac7273"
    sha256 cellar: :any_skip_relocation, ventura:        "fbfa9c5d7b93718ffe65be282f3b61329b70586c28ae7f189c2ba2e396305f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "a14cc0210b445ffa210b01ce1bdec6a3402b729482f8115cd2647f86f9170109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8fdca360334ab37c8b6b30a9869628e1a541b553c4a184fe0aac9df13882027"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
