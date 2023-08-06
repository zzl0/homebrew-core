class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.2.5.tar.gz"
  sha256 "a93d7c05534723e3c7b2fd25c624e5ad83098d017d99138b5c6ae60b407830ba"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b6b05f4b402a73870486a63e11908b73062052123d3f861d7ab6685373bcef0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "908974c441e1ab97c2ba3d7a70857c06edf5c588e2aa1bace8dff1e8d3f0182a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a441d7e0291084a7cc10eccc1e3a14fa5dc9a9ccaef2abae9f88d98d9b7b8eba"
    sha256 cellar: :any_skip_relocation, ventura:        "24b3748759a45c6c40415519bfcff734a7ab404f121a8f793437cebb1c5e60af"
    sha256 cellar: :any_skip_relocation, monterey:       "934e30678491d607510c2159926baff095ea5a6c6944f36a040226943af1f0a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "70d36b050e806299cabcb2517b2a97d543ed3d463396febb64313e5f434e1f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cdb7eb0ce2aafe9c202dc2ed658ef76852c8f2f96384d5aa992219a23748df1"
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
