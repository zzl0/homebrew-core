class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.3",
      revision: "9a87e6fd820317b1235e1b75bc884ce34c375dd5"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a7204e0f2b453812ec83ef4b418bcc83dab1ba87057cb317c6ba97f2492f65c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a7204e0f2b453812ec83ef4b418bcc83dab1ba87057cb317c6ba97f2492f65c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a7204e0f2b453812ec83ef4b418bcc83dab1ba87057cb317c6ba97f2492f65c"
    sha256 cellar: :any_skip_relocation, ventura:        "8310a0a0199f5bc67120f64ba94412e7e857e745d28c17fee65773c28a10d476"
    sha256 cellar: :any_skip_relocation, monterey:       "8310a0a0199f5bc67120f64ba94412e7e857e745d28c17fee65773c28a10d476"
    sha256 cellar: :any_skip_relocation, big_sur:        "8310a0a0199f5bc67120f64ba94412e7e857e745d28c17fee65773c28a10d476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b458db8911e101094b9b1937e12d5693eedf16951d219d1651395006973881"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    ldflags << "-X main.version=#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    EOS
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
