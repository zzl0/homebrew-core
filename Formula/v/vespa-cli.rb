class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.215.17.tar.gz"
  sha256 "22d527e1e6b3c71a0988a0c01907c17c1ef871b48639eddcb1f981d17ee3d3d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3a8b740b845f26249956e2e5ab851ddecb3cbc26248a5bb0b0e08bc19a72e8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ffdb5d9d7037c6e19d4dcdc69f8863d893405e493da3f33e7304dc34ab39af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2d969503b30606fa146194c256c7cc2135271ad04cf5ef32651d4cfa66faa0f"
    sha256 cellar: :any_skip_relocation, ventura:        "c2a5a35432d0b603e277115f5558e9100dd5542910f526abdef9115b25902126"
    sha256 cellar: :any_skip_relocation, monterey:       "2c403e3df1d8f33b711b52b49466839683f7f6c3ec5f1e82e5035c101e3fd492"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bbc9d5987eefb268065cd3805edbbd8a81eafcff0a82de5f2b04d5b427192bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c6a7d434ecc002a2264939b0817c77a205bbde6facab7390d0a145001345bee"
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
    assert_match "Error: deployment not converged after waiting 0s", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
