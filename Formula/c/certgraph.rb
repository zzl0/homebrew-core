class Certgraph < Formula
  desc "Crawl the graph of certificate Alternate Names"
  homepage "https://lanrat.github.io/certgraph/"
  url "https://github.com/lanrat/certgraph/archive/refs/tags/20220513.tar.gz"
  sha256 "739c7a7d29de354814a8799d6c5ce4ba2236aee16ab7be980203bc7780769b47"
  license "GPL-2.0-or-later"
  head "https://github.com/lanrat/certgraph.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitDate=#{Time.now.iso8601} -X main.gitHash=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/certgraph example.com")
    assert_match "www.example.edu", output
    assert_match "example.org", output

    assert_match version.to_s, shell_output("#{bin}/certgraph --version")
  end
end
