class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.37.tar.gz"
  sha256 "cf71f942923366190fc26fef28e76cbae7af1d40dec162b7f285392bb4b4a0a9"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2781511f4344e8a29fdcc5759e93eaf7684be4748701e31c095c7dac4e302afb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09acfd6c26a86e81273082bcd0ad8b2035b420bd7cd57630b36948a58fe0c589"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d0e9197c352303bc1ca8fb95b5f597afde7f2cbbf546cbfd58728ff677fd16"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3ced64157913298f5c5261127dd419c9aadd5ae4561b00020a6fe0dca04bacb"
    sha256 cellar: :any_skip_relocation, ventura:        "0b2b54e8ac8cfef6e6ec2bb6565428faac508f49d367c14342f54cd4e9d6f685"
    sha256 cellar: :any_skip_relocation, monterey:       "4b0c6c11a1c92f68193d711928251b7cd64603e8f4142869c224719706b901b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9610bf34a8818b1101ce4ac4959f8b51644d51dbe2113889a583b28d6a92ad4"
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
        #{opt_bin}/rtx activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, rtx will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
