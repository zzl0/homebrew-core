class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/refs/tags/0.7.0.tar.gz"
  sha256 "d77946c042df6c27941f6994877e0e62c71807f245b16b41cf00dbf8b3553731"
  license "GPL-3.0-or-later"
  head "https://github.com/jmacdonald/amp.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74097d45b7ef924dc90774e815cb23079176494860f4844944f5f6ebe2884be7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d19e2cc1f1bdc9cf5372a8af26514dcd2bce4945d15bb983c2f42925fe2172e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae421ef5b240a2fa442897dc594c237a77b7f72de3d8566cb3e99776552b62bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82e8807dab0c43b84aaf807c0e458214e70705333f55a67b31ead8eb78d4dd5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "abe1b665c1912b8c4b1ef306c4d4cbd270641c616b48d243388ebadf4b6ebb14"
    sha256 cellar: :any_skip_relocation, ventura:        "667e2486099549c5d67c2d22e03619b957c196cf3b9d07c3fcec00590698f7ee"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b628ccf34ed9277b22f908d57ea12ffca9f4f71af25be554548e20e7e55783"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0813560d9c8739aee6559aae7c0166ce425db267dec97139007ba0a2e62caff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1dc1298c845079321d6456053f16d4716c726b55da1c891e11107115acdd0d2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    PTY.spawn(bin/"amp", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # switch to insert mode and add data
      w.write "i"
      sleep 1
      w.write "test data"
      sleep 1
      # escape to normal mode, save the file, and quit
      w.write "\e"
      sleep 1
      w.write "s"
      sleep 1
      w.write "Q"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "test data\n", (testpath/"test.txt").read
  end
end
