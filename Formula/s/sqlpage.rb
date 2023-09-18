class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "c45943483027a7932fb72c6935fa92f10927c50ed57830e77865e85bd96b2123"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "557f08fabeba38549c643ccb91e60027e0f97dd35c027cda1315f859f24292ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9723b2b04b486acada6d551ec6b382e44b6f29b572cf5dc4b994f0a6a0bf092c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59f141e6f4321be45fc836af774ba82de03bfbed574a8f7ac4c77ccbd486b5a2"
    sha256 cellar: :any_skip_relocation, ventura:        "7135cc83148f6f9657d7246b5d41abd28c852b2ae4b4755746f9a7916eb18e11"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2b307faf34e39cc68a6faa0495258493fa9c373299de8f4ccc1be00d6f4b8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5ead479f9d84857e1727e738cba5fb3fae77982ce619a803b3098dba3a2c07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14c7d00beba0de9c83e98bf57291ef96f184f266cef021bcc9d03e6b8803f6df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end
