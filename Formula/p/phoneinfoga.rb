class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/v2.10.8.tar.gz"
  sha256 "7aef72755c5bea9ba80b73dcacc7757d3933ffb135d7a3f8e8ee5786a764e852"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf74cd5fb71e8b2a1d3920eea406447493ef8806871feeae388ccc9682500daf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9100c5e0ba78209bb4580f74d02d695383135ebe4df0a90fb3837917cfa4815"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a5c0ea3a3feb9b467a364a1da080bc0f2e57a92cecc594390173d14cf5b5f63"
    sha256 cellar: :any_skip_relocation, ventura:        "3a2a6f3bb2c5fe8b1114fc7e34a0df1f2898f0f680fd7674c71cf47f5eb920a6"
    sha256 cellar: :any_skip_relocation, monterey:       "2110257f4ca48f0871c0c5e4950079e349b75a20e9f1a67328a470ac9c581054"
    sha256 cellar: :any_skip_relocation, big_sur:        "b470203c50643f8066c43578503ebc17196ddd75979b0fb6c66c6a20f345037d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a05f43ad897b28377cf8043cc9021ffa61a3ae1ab33a4aaeddd826d5a4cffcf6"
  end

  depends_on "go" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    cd "web/client" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/sundowndev/phoneinfoga/v2/build.Version=v#{version}
      -X github.com/sundowndev/phoneinfoga/v2/build.Commit=brew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "PhoneInfoga v#{version}-brew", shell_output("#{bin}/phoneinfoga version")
    system "#{bin}/phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end
