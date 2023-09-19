class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.227.41.tar.gz"
  sha256 "32a8a530d9198df47a7286bbe3ca42e0e80d4e16decb26ff25a93b5da5b5538e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac80732fcd7e1e4904d5bc90d776a2be038b15c7ec6839d014e62261b7b33af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1dd2059305331a67a09159d1981d4ae5cb6dfee56930c1420c9bea396d99e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "672b8f874a425e1c5f3485985210098e803dda0261bcc14574929cb3f7ecbddf"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7351b3072545a8a9ea335409e7ebdd20cfe1feec6a48f22ebcd70fc83eb953"
    sha256 cellar: :any_skip_relocation, monterey:       "9deb1742044a9f2703ab411d3b8339a032f128908e31025286bfb58a7bd50090"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5c32ddd78e26ba20bd1984ce2c78e52b6d23ee1231a81ce0f8d0dd8c2c99741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8dab751a3bdcc6078f8f2046eda437e84aca999df1803c2cfef564e012763ac"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
