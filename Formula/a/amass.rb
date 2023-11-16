class Amass < Formula
  desc "In-depth attack surface mapping and asset discovery"
  homepage "https://owasp.org/www-project-amass/"
  url "https://github.com/owasp-amass/amass/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "cc6b88593972e7078b73f07a0cef2cd0cd3702694cbc1f727829340a3d33425c"
  license "Apache-2.0"
  head "https://github.com/owasp-amass/amass.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/amass"
  end

  test do
    output = shell_output("#{bin}/amass intel -whois -d owasp.org 2>&1")
    assert_match "blockster.com", output

    assert_match version.to_s, shell_output("#{bin}/amass --version 2>&1")
  end
end
