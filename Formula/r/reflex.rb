class Reflex < Formula
  desc "Run a command when files change"
  homepage "https://github.com/cespare/reflex"
  url "https://github.com/cespare/reflex/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "efe3dc7bc64b5a978c6e7f790e3d210aed16bd7e43c7fbc2713fe4b16a7a183e"
  license "MIT"
  head "https://github.com/cespare/reflex.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/reflex 2>&1", 1)
    assert_match "Could not make reflex for config: must give command to execute", output
  end
end
