class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.213.13.tar.gz"
  sha256 "e046740fe961d3c41a97fb0e81040a0678f12f8545d1fc595e92d108842e21d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc48088f9f749a1ba823533cd750e5d3989f299343322b83ca255bc4de5f0133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7de2bfe32e58fe258ad6a903f97dab1c86bb9791a2724c848afe6c5f93920a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "836cdf2c6e7e4eac9f7121aa691c838400cf83b58f25fc1276f022cb0963eead"
    sha256 cellar: :any_skip_relocation, ventura:        "6bf02d5afc68946c3d05260f76853a2e6c9654737b14a9a4bf7c9b8a2e207e12"
    sha256 cellar: :any_skip_relocation, monterey:       "bfda3ff0879276b1372b41947b64a5863a2204ba5ed5f8f8aa76d15aaa755daa"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb3a8c2b4618376380a2fa36a3995b735545d89b9127e4ed653849e2d9ea27de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91f36f9413ab6f2c897cd1ff92d9de50348a2a0bd93a30bb6f5447f88d51c502"
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
    assert_match "Error: Get", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
