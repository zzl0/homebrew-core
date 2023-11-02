class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/1.6.1.tar.gz"
  sha256 "244163902523c9350658dca6b9e74aaddeb7635bd9195e21f8cfde0b62844e8e"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/spin --tail 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/spin --version")
  end
end
