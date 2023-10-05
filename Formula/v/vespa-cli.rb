class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.237.19.tar.gz"
  sha256 "e8c5520029b0873e1493c9c9432a51a240d583b7bed3e66faeef2bb1afd7f76e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2b4fecb283365538ca33920fb2c535dbe1c4053deee25cd4288395e2831a666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58e4a79dab54a33243674122d57ffe4b192cc773c8f3f08be31dadb947731458"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7947d62044b0e80b9f23966b79a57f0ab978b21ed86ce0af8623fb0220d520c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2e040d6595d4d679fdaa996c20306ff4b79e23826b9f6f51b6a71cda2814167"
    sha256 cellar: :any_skip_relocation, ventura:        "225495d69187fae198c8e77178da451b47c266da252759b0d0a8717e566ddb24"
    sha256 cellar: :any_skip_relocation, monterey:       "c55d09a3ea7b97831407f30f8c080e4f645cde2789f8dd2b96dcb67301f0cb9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54eaa500693a0cff2de028f1c411a1fb0ae5e738c8917caa835e16c746509e4"
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
