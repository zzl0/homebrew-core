class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3d0d80f13cbb13e8f1afc0fd4503f661835ac978ad730c8b57422b13d95657e0"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/presenterm non_exist.md 2>&1")
    assert_match "Failed to run presentation", output

    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
