class Proxify < Formula
  desc "Portable proxy for capturing, manipulating, and replaying HTTP/HTTPS traffic"
  homepage "https://github.com/projectdiscovery/proxify"
  url "https://github.com/projectdiscovery/proxify/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "c3e99a94778687027806d1ad5511e23c86fce99bf3018d52119f28cc6ee3de17"
  license "MIT"
  head "https://github.com/projectdiscovery/proxify.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/proxify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxify -version 2>&1")
    assert_match "failed to load open", shell_output("#{bin}/proxify 2>&1", 1)
  end
end
