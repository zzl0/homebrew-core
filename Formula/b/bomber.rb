class Bomber < Formula
  desc "Scans Software Bill of Materials for security vulnerabilities"
  homepage "https://github.com/devops-kung-fu/bomber"
  url "https://github.com/devops-kung-fu/bomber/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "bc5e372d6f336c54f676fa9c7f39f20983987590b826962eca1e4a16109cc8f6"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bomber", "completion")

    pkgshare.install "_TESTDATA_"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomber --version")

    cp pkgshare/"_TESTDATA_/sbom/bomber.spdx.json", testpath
    output = shell_output("#{bin}/bomber scan bomber.spdx.json", 10)
    assert_match "Total vulnerabilities found:", output
  end
end
