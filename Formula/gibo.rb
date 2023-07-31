class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/v3.0.4.tar.gz"
  sha256 "07f11ffce1d29bf3feacfe4f7187c9be2e1dd2e779d2899855f15175efdb3ca2"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b725b6335c764866ea6279b0b85875d51db8c880d9379ac0c701e9cfa4d737d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b725b6335c764866ea6279b0b85875d51db8c880d9379ac0c701e9cfa4d737d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b725b6335c764866ea6279b0b85875d51db8c880d9379ac0c701e9cfa4d737d1"
    sha256 cellar: :any_skip_relocation, ventura:        "b20bdfe8d3bec651ab087329b781f198887be102b49633f3db0e891027f25f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "b20bdfe8d3bec651ab087329b781f198887be102b49633f3db0e891027f25f4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20bdfe8d3bec651ab087329b781f198887be102b49633f3db0e891027f25f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbc748366560716f6105d419327e0ea576f0e337000fa47ad1a963497f07697"
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
