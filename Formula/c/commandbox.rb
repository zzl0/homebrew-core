class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.9.1/commandbox-bin-5.9.1.zip"
  sha256 "d0f395dc8a27ff26528a5e6562d2c1b90770380387fe00cce9d3d1387e0ac466"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2561661c36f87a0286846016bd982e35f09611d8b1be0c3d5d36b06363528840"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.9.1/commandbox-apidocs-5.9.1.zip"
    sha256 "3d9d57c2dd062fd370bb4e799b69f603af71fa7e0c7e4c62973af502837fb0ae"
  end

  def install
    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env("11")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
