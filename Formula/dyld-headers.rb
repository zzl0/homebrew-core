class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1066.10.tar.gz"
  sha256 "ef526cfa01be737ca62f630c3b946c89f99c33f91565ab086ed64f9176fbccb6"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f833f5fe92cca8a389b735cb6510db079819a7d68659665af1fc79f29569114b"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
