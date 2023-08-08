class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/v3.0.7.tar.gz"
  sha256 "1e07ca4d5e7a0303784c42c5c9633b63cc0532d5b9dc69e7400caa501be51497"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3da4cc1f1d01e5a564fdb7f46d7228b8a6a9b90fc61392ce02d9f876e5917192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3da4cc1f1d01e5a564fdb7f46d7228b8a6a9b90fc61392ce02d9f876e5917192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3da4cc1f1d01e5a564fdb7f46d7228b8a6a9b90fc61392ce02d9f876e5917192"
    sha256 cellar: :any_skip_relocation, ventura:        "db919aa67bf7cbe3c2de1ac37b67184d285b3378c0c91d8b4aa10550c07282e2"
    sha256 cellar: :any_skip_relocation, monterey:       "db919aa67bf7cbe3c2de1ac37b67184d285b3378c0c91d8b4aa10550c07282e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "db919aa67bf7cbe3c2de1ac37b67184d285b3378c0c91d8b4aa10550c07282e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8274e1cb0a585e88f7a8addc48d92e10ac337430bea14dbfdd606e0c26d01733"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
