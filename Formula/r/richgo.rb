class Richgo < Formula
  desc "Enrich `go test` outputs with text decorations"
  homepage "https://github.com/kyoh86/richgo"
  url "https://github.com/kyoh86/richgo/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "811db92c36818be053fa3950d40f8cca13912b8a4a9f54b82a63e2f112d2c4fe"
  license "MIT"
  head "https://github.com/kyoh86/richgo.git", branch: "main"

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module github.com/Homebrew/brew-test

      go 1.21
    EOS

    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func Hello() string {
        return "Hello, gotestsum."
      }

      func main() {
        fmt.Println(Hello())
      }
    EOS

    (testpath/"main_test.go").write <<~EOS
      package main

      import "testing"

      func TestHello(t *testing.T) {
        got := Hello()
        want := "Hello, gotestsum."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    EOS

    output = shell_output("#{bin}/richgo test ./...")

    expected = if OS.mac?
      "PASS | github.com/Homebrew/brew-test"
    else
      "ok  \tgithub.com/Homebrew/brew-test"
    end
    assert_match expected, output
  end
end
