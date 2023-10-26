class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.14.1.tar.gz"
  sha256 "d321ddc9cfd3eba729d2c91e063fd63c6174d027be3d2635bae3ed4b7e952af3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbdb962eb10c0ea710c15e0a1aa14bff8343c9a3009cbcbc85b0512543c7cfc0"
    sha256 cellar: :any,                 arm64_ventura:  "701273e307f5fb1552b6c6df36d4ba2041689cc9097951686bc7e0f7cfbf32c9"
    sha256 cellar: :any,                 arm64_monterey: "42f17fc4d98951e554c1cfb22fc52fc5f8a43020117566aa0f87a6a0214a8734"
    sha256 cellar: :any,                 sonoma:         "07267b9775ca6b681a26ad87fe346bde4fa199798ada20f8e08564f83325ed2d"
    sha256 cellar: :any,                 ventura:        "70c7bbb4c41d8dfd7a3489c8c784e8b1bf3d3e56286a93ff347410d0d38bf349"
    sha256 cellar: :any,                 monterey:       "b839c266d79f379761a14f8cdfd22109fa3c6399c9dd5a60256384738bf8c15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65a2ee2887592fe5fd5f0a64346c7991bb8c583583e8f7fef0d35136ed26baa"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

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
