class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.15.1.tar.gz"
  sha256 "a4e28a6c41fecf8e6f7251741a259c1c86525734cd528693ec8ea3d70276bea3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "07bf6092e5d22b7de12a27b4a3c632b85dadfd5190a5ebfc6f542b268df0cf25"
    sha256 cellar: :any,                 arm64_ventura:  "72a44a21979db1e2090a242d3da91bfb54e65cf4e24d621ea7d68d68cb3d864a"
    sha256 cellar: :any,                 arm64_monterey: "c409763a383f61076a1b93c7f0ad840954a5f71282ec78bd4fef8adf900c9d45"
    sha256 cellar: :any,                 sonoma:         "585afa675d499584cbae854b50279ecf8f02b14468bc42c7ee51999b99916827"
    sha256 cellar: :any,                 ventura:        "0d9504b05be5360a7084d614023ab49b6849a0e8c20e4b6a5e18ee7080b31a6c"
    sha256 cellar: :any,                 monterey:       "d07dd81df6393caca6d534c9ff9ad772be90cd94190f3f77d2a572e344a500f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b0021fe92f8f00d9dd8a3941a45f2c2b64a24e054fe85862b05715a82f6cb87"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
