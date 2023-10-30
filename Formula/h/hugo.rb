class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.120.1",
      revision: "16fb2cae88eb6add7d12e9fbfcf01d8670e60a35"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37301fea5df9acedeaf2a472c5489366687be7496af3a3acc23ad2bd39cd8cde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f388f378b13ba69968b955d0cc5b28bad23d2b93cdb5eba90408a6695cc3fa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b972c71e0db2621c86961c0c0f72e0f5ecb5c60266731c4c41cafff6dcf7e87"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cfc2993bfa5e10fdaaac98ed1b926c9a1ba32f4f1dc092e2bf1089be7376fb8"
    sha256 cellar: :any_skip_relocation, ventura:        "1482447774845abfeb4299e4d7e8ef68a619e6ad8ce1f9397fcefcc2ef6579ac"
    sha256 cellar: :any_skip_relocation, monterey:       "f0f69c0849990812537c74f6d377fc93d4a3214501874bc5a6c64c9c544b9dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb97e130680a394fbb357564558766ff65a62061b65c19c025ed608d9ed036d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
