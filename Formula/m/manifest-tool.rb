class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "74937119430d24397684003f0d4ba30f3e362742caecf3e574e968a3623df83e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d7573b73e5095119ba98372844dc301dff178f609b26f9f90efd4d441969b54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2daf8c8c84b0ebeae21a13afa00f8bc9fa545008e9c1c43049ed948fceff077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8d068d20ad50905009e0dbdc426217aa862b6c29afd5fa3eef160af0058dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6daa891e3024dd1c75056b8bd0e61383bd039fcabce6519c3b9fabefccd16237"
    sha256 cellar: :any_skip_relocation, ventura:        "0027b517c3dfb485f524de1ca119805817dde49fdb98b9a144f1b38c1be9fc83"
    sha256 cellar: :any_skip_relocation, monterey:       "7a55c557ee8fa08e6d80ab37abe305703afc17526ad24bb4aad3ef9935364d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f4e01317e754f36cd3ca32ee7bcfbca2b985058fca20e2ceee7368153c8bdf"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    package = "busybox:latest"
    stdout, stderr, = Open3.capture3(
      bin/"manifest-tool", "inspect",
      package
    )

    if stderr.lines.grep(/429 Too Many Requests/).first
      print "Can't test against docker hub\n"
      print stderr.lines.join("\n")
    else
      assert_match package, stdout.lines.grep(/^Name:/).first
      assert_match "sha", stdout.lines.grep(/Digest:/).first
      assert_match "Platform:", stdout.lines.grep(/Platform:/).first
      assert_match "OS:", stdout.lines.grep(/OS:\s*linux/).first
      assert_match "Arch:", stdout.lines.grep(/Arch:\s*amd64/).first
    end

    assert_match version.to_s, shell_output("#{bin}/manifest-tool --version")
  end
end
