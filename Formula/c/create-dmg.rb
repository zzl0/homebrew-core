class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "359263a9d586f10107c6b77178bf57a9658917bf57db44d350b35a50002810c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5e0bef6c032eb5a47e84887ac1f04e48441f9056144169a2bfdf32e94adf4a3"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", "--sandbox-safe", "--eula",
           testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
