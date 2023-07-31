class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.8.4.tar.gz"
  sha256 "a14ac39d1dbda17258da2c845a08991b883550657c4d40654940cde183b3f709"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "122c528d7dd8cc2934471c68c7baacab9be621639ca23e19521d3a785b7e5307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122c528d7dd8cc2934471c68c7baacab9be621639ca23e19521d3a785b7e5307"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "122c528d7dd8cc2934471c68c7baacab9be621639ca23e19521d3a785b7e5307"
    sha256 cellar: :any_skip_relocation, ventura:        "cfdb049556ea7690247e6771d6f8401a2e2834288b1d5a4d18f7106c5446d927"
    sha256 cellar: :any_skip_relocation, monterey:       "cfdb049556ea7690247e6771d6f8401a2e2834288b1d5a4d18f7106c5446d927"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfdb049556ea7690247e6771d6f8401a2e2834288b1d5a4d18f7106c5446d927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15738d4b24720ff9456aed0b969d1f62ea2a116bfab870f551c11258916542d1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
