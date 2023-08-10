class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "fba6859bbf30c1175b2ff4a9978af9571494564cc3da050151773ad5f95769de"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/uncover"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uncover -version 2>&1")
    assert_match "no keys were found", shell_output("#{bin}/uncover -q brew -e shodan 2>&1", 1)
  end
end
