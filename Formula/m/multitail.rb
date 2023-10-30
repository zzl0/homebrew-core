class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://github.com/folkertvanheusden/multitail/archive/refs/tags/7.1.1.tar.gz"
  sha256 "fa9ed63c1501c5c06c8b9713e7b1fb37d4223e815f07878078d820c1370f6dc1"
  license "Apache-2.0"
  head "https://github.com/folkertvanheusden/multitail.git"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a7abf3e9432f663dadd24eb0358949ed3a6fc9563a3fb75affa7fb4ad23d7225"
    sha256 cellar: :any,                 arm64_ventura:  "36a558274f68601894f69bad2c76067c84dcd93c0bb0f8a8d7707bcc64184127"
    sha256 cellar: :any,                 arm64_monterey: "764942343f5b7d5b85dad59fbdce1f205903e1a2e7e5cea56886bf37eae3f918"
    sha256 cellar: :any,                 sonoma:         "91ac1e160fbb6a6e4ee590fdc1111eb2ec08e814aac509614191d6672f0a785a"
    sha256 cellar: :any,                 ventura:        "2e4a9df2577a707edd7c68d4a69eb2405777d223481c1a440a775533014362c6"
    sha256 cellar: :any,                 monterey:       "f5d069f18899048c02379a45f8abb47db111f77a70c6bc9b18dad171e8f38b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "029b1f39b69a347c51f0309e62304d69b5548f3e2983d6618f1b20a1fc61e1e5"
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  # Fixes segfault. Remove in next release.
  patch do
    url "https://github.com/folkertvanheusden/multitail/commit/47acfbddf43abb92eaa3fe191189aad6312ffe6b.patch?full_index=1"
    sha256 "3bd6dce3e8df138f942662b4666d95d836692b315cabe8edffbb43a3ebc90ba7"
  end

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install Utils::Gzip.compress("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
