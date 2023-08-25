class Goread < Formula
  desc "RSS/Atom feeds in the terminal"
  homepage "https://github.com/TypicalAM/goread"
  url "https://github.com/TypicalAM/goread/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "8b28b7dd572164bf99afba38edd19bb19f2ba778a69ef06eca64426ed1ef5168"
  license "GPL-3.0-or-later"
  head "https://github.com/TypicalAM/goread.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}/goread --version")
  end
end
