class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/refs/tags/3.3.31-1.tar.gz"
  sha256 "5e2cce705a1dc865e8d90e63d4668f7a946b1349bf8bad141ddb69718fd46b60"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bf92e5b2425d91c06933700d8719a573448e553bbe4e4543251a5fb23449c82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bf92e5b2425d91c06933700d8719a573448e553bbe4e4543251a5fb23449c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bf92e5b2425d91c06933700d8719a573448e553bbe4e4543251a5fb23449c82"
    sha256 cellar: :any_skip_relocation, sonoma:         "b790a15267f94236a31ac61cd2ccb76718e09b95439cb64eadb7cdc865b3f7c7"
    sha256 cellar: :any_skip_relocation, ventura:        "b790a15267f94236a31ac61cd2ccb76718e09b95439cb64eadb7cdc865b3f7c7"
    sha256 cellar: :any_skip_relocation, monterey:       "b790a15267f94236a31ac61cd2ccb76718e09b95439cb64eadb7cdc865b3f7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bf92e5b2425d91c06933700d8719a573448e553bbe4e4543251a5fb23449c82"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
