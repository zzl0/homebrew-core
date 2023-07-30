class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/v3.0.3.tar.gz"
  sha256 "d3d76b30d8c61d203304af1805ca3abf77e96c6528f468c4d14830656f982f5c"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, catalina:       "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
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
