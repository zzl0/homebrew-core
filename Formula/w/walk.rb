class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b6ba7a5e3873a25944e0f18c8a3ebbfdc0e8681756517905c75972c824315970"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7831e888ec75cde4f3c3e2a875eeac242070970c519adbf6311238421940be49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7831e888ec75cde4f3c3e2a875eeac242070970c519adbf6311238421940be49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7831e888ec75cde4f3c3e2a875eeac242070970c519adbf6311238421940be49"
    sha256 cellar: :any_skip_relocation, ventura:        "55c3b8b7e7a9b3deb96c2c4236a5f65f9bec6d9804ca2f95a91de35f49f4863c"
    sha256 cellar: :any_skip_relocation, monterey:       "55c3b8b7e7a9b3deb96c2c4236a5f65f9bec6d9804ca2f95a91de35f49f4863c"
    sha256 cellar: :any_skip_relocation, big_sur:        "55c3b8b7e7a9b3deb96c2c4236a5f65f9bec6d9804ca2f95a91de35f49f4863c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55cad7718ec9e81bafac61d24d512ca7acaf8c741dfd4343e88ba2073160e69"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
