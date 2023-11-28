class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "ddf2fb1fb2376d31957415d278bc34ff0ef574eb69ef96ddcb564c392d2e4c27"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "767594a921a1370dbb8df28cb61132ac7899b383f427f6c0982eb1bbf6087566"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca4ca9178030af9b0418c5ff18f32100a2b27841e97d517e7e682c3f8cf82e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2596728ac480126f610db00094ea24168f4794e553691dc867f6dd81903b78c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a55ffc2499c1c3e7bdaec136c66d8b6a29c5ca921510cd61c95d939e44908be9"
    sha256 cellar: :any,                 sonoma:         "4ad540742905fb9ac09f04037cd4832d176f096054fc7fb019afe9a56ceda570"
    sha256 cellar: :any_skip_relocation, ventura:        "6d62754ef58b5a4e69554c1e4cbefc140eeec20cfbddd09dd276e293d202bf47"
    sha256 cellar: :any_skip_relocation, monterey:       "171645ac338541eb705d2e6f61b07bb33c111f69ac228e0e0df517e2c252db04"
    sha256 cellar: :any_skip_relocation, big_sur:        "75b753e2434611fac670caafee952910087c0111867abfcc0499d0eba5f604a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0371ef38e8aee61aa5ee4a383e3eb5d4df72f340647bd531ac6adfb9d684fa"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libdeflate"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libsixel"
  depends_on "openslide"
  depends_on "webp"

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
