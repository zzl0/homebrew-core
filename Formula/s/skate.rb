class Skate < Formula
  desc "Personal key value store"
  homepage "https://github.com/charmbracelet/skate"
  url "https://github.com/charmbracelet/skate/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e982348a89a54c0f9fafe855ec705c91b12eb3bb9aceb70b37abf7504106b04e"
  license "MIT"
  head "https://github.com/charmbracelet/skate.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"skate", "set", "foo", "bar"
    assert_equal "bar", shell_output("#{bin}/skate get foo")
    assert_match "foo", shell_output("#{bin}/skate list")

    # test unicode
    system bin/"skate", "set", "猫咪", "喵"
    assert_equal "喵", shell_output("#{bin}/skate get 猫咪")

    assert_match version.to_s, shell_output("#{bin}/skate --version")
  end
end
