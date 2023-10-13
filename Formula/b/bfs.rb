class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/3.0.4.tar.gz"
  sha256 "7196f5a624871c91ad051752ea21043c198a875189e08c70ab3167567a72889d"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3712919efb8b9412915adb24b05b2d09440b1d89c66ca31d67738c35b191cb76"
    sha256 cellar: :any,                 arm64_ventura:  "bbce0db13af693dbafb1a6446bf061e40a725420ed09386e49e42969d33d7239"
    sha256 cellar: :any,                 arm64_monterey: "5f66ea744bd1907f7b5826a7b71b84a2c3b812ca13572dbb509bd54f97ad417f"
    sha256 cellar: :any,                 sonoma:         "a493a9a7edd398c67d4d94b9235ada1294c117a70d2087565fc1cf3c3dd4d505"
    sha256 cellar: :any,                 ventura:        "9d8574ae854b5db01ecc000ee7e6995a3fce4ffb1fe7db651ac14de762b93632"
    sha256 cellar: :any,                 monterey:       "a7979cbe57addcd23bf5837d1135c3c1b621c22e35992842c1030fafef9e0ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b8872d15af24b198ec2ea6984d097e27e88500e0c485b63aca2c9c5858265fb"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "make", "release"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end
