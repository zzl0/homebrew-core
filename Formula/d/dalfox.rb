class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "aaeac4663757b1c0a1477d78cc6c793023ac01c154ec79f6a1746db7d0cf1b2d"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"dalfox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox version 2>&1")

    url = "http://testphp.vulnweb.com/listproducts.php?cat=123&artist=123&asdf=ff"
    output = shell_output("#{bin}/dalfox url #{url}")
    assert_match "[POC][G][GET][BUILTIN]", output
  end
end
