class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.3.0.tar.gz"
  sha256 "d81799964d5ef663cce8e678925cac70e5cbc153898c566ab4bb59bd82113775"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e171c459d0e20db71e3749b6e962410e168234f7a0ce3e5a03a20dfc3c3f6b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a057cff0e6b2e4ffb561dbfbe8c5fe6dcea741801a5bccd21b5914b7e6dcda82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd50be259a79c20b19bfd337e7ca48fff19d4671211353aa56e71b699eb599b5"
    sha256 cellar: :any_skip_relocation, ventura:        "e2cb151ea255bc6519f0c455efe8804bab0ed9f23f2d48e69af43b6f4d52f3bc"
    sha256 cellar: :any_skip_relocation, monterey:       "11feb14f22d67b2ce5477c5cb9094e93cb1d373e695c01122d414bf8e5f44615"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5a5374908e056cb01a4c50d64b91d75fdc4b92d210664f841291c7676a3c6a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1540f6cde261659332abb13a91d6e67d8db6a361cc08be5bd98ff9d12428c9cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
