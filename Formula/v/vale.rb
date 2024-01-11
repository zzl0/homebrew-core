class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "1720de7c875879fff770235f15218ef915ada4ce360a54d11e4f9e75ff5c8380"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9c36979507ae82bdfc344953e1cbd4a4f36052b903615a38e9ab3edbc9ec693"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbc19bc6c0d7c2bc32747c3bdef55e07b0eb727d6005d751f364c135d4bd73db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caa05609c3ff8de6f414709027defab2ee9148a29aed3e20288d75d04e466a97"
    sha256 cellar: :any_skip_relocation, sonoma:         "ead49a624b9a39fc0afbb7aaa827a60c6f8cfda7aef8425434d767982ba9094b"
    sha256 cellar: :any_skip_relocation, ventura:        "144f063608bcd104ef0311a2e71e9768c781c211b79a40dc147279179c315c11"
    sha256 cellar: :any_skip_relocation, monterey:       "a255625168167b8f7aff60643681e84c5ce5bff4e8b67fc7960509519f3562c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a8c626e57567735a414fab794d374d4d2ba4259ab29b505c44c911bd44e6f6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
