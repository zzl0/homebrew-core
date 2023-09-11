class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/7.4.0/rswift-7.4.0-source.tar.gz"
  sha256 "0f9c88a46b826d0e6bbb1e9a73edc5039013d43b78948bb286e6a879959d2a9d"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b00dd4ed8e276e791c76953ccc4ffd06e18706d1500fdd6d288d1c65ba9c81c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0acecba238b6d6a01fc46b4efc5acbec6c5dcf08c98e398d73aaf4b6da719c6"
    sha256 cellar: :any_skip_relocation, ventura:        "fc56c6138e812ae7501339ed6c925b1d6e137a37c1193747bb00dd26e4a9d67f"
    sha256 cellar: :any_skip_relocation, monterey:       "d4bd872647c09e96fce4e91765eedcb2321f6e19807a4524b2c5bab1dc291266"
  end

  depends_on :macos # needs CoreGraphics, a macOS-only library
  depends_on xcode: "13.3"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    expected_output="Error: Missing argument PROJECT_FILE_PATH"
    assert_match expected_output, shell_output("#{bin}/rswift generate #{testpath} 2>&1", 64)
  end
end
