class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/refs/tags/3.1.0.tar.gz"
  sha256 "5f45a9079da6b3cb7e832ae0dd8c10cddf96fb8ab9096a6c5cf74bb9f09950e7"
  license "Apache-2.0"
  head "https://github.com/kcrawford/dockutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5f87d9e286c2b294bb157ac9f87baa2720fff044c7a92c0b80b9cb82db8a87e"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
