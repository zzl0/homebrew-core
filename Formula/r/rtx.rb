class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.30.tar.gz"
  sha256 "c4e07cf0762cf91a547fccf7c39e4f939a96675a8d926e10029ec9026197c72d"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80c3c075a7e15f99739daf4fed3c75007059d697920b14b93d46f300df70c64e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcaf97f92dbf543065613c6cf19adb56a8225139ea3d5d354c9dcf03ce270f3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3da6ab547c986b46199e5b85cbb526bab28d36e80492394423a86c93891984"
    sha256 cellar: :any_skip_relocation, sonoma:         "b143f568adde5aa2cab79098607be7a63836a16c3841618b217354553b8e97e0"
    sha256 cellar: :any_skip_relocation, ventura:        "004ec8d2f74474563b912443b2d9ecd6b6965c05976becc6eef5517a8b7ffda9"
    sha256 cellar: :any_skip_relocation, monterey:       "1b0581850a6b9a81a165e203f36156ea6706726ae6b525a2d3a6355070dd49bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7475d601374caf2d0663e710bf9a076317653a60a4d3f59ee15c892e79380756"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{bin}/rtx activate fish | source
      end
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
