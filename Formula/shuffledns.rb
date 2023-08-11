class Shuffledns < Formula
  desc "Enumerate subdomains using active bruteforce & resolve subdomains with wildcards"
  homepage "https://github.com/projectdiscovery/shuffledns"
  url "https://github.com/projectdiscovery/shuffledns/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "ce61eb210c0bb7ff5cc2e0d45e90129764494d9c0b8883e04fe67b16169ab707"
  license "GPL-3.0-or-later"
  head "https://github.com/projectdiscovery/shuffledns.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shuffledns"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuffledns -version 2>&1")
    assert_match "no resolver list provided", shell_output("#{bin}/shuffledns 2>&1", 1)
  end
end
