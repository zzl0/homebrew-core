class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.10.0.tar.gz"
  sha256 "2c2362e0308e2d83cf235aaae7fbd0174ae370919791788968d5926e299cb16b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "785b7e59e197dd28d0f81cf63a434ef4ff833d7ce05c933dbf13010b71801c83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c85824ee9bcee910ccb8d5010b6d5dfdcf2ffee090dfc34fed1d4b94fca921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ca2b4f76e743168280af77274c91dd11caa665aad333e0397fba80d8ee821f1"
    sha256 cellar: :any_skip_relocation, ventura:        "37fa859cac694966bc18dd4722c29a78b2d3971c4d54375410b9558da0f72e78"
    sha256 cellar: :any_skip_relocation, monterey:       "fcdc24ea356c7518480ee86da86c249def6007de414c8c3d4ce751f7d43f0122"
    sha256 cellar: :any_skip_relocation, big_sur:        "459f4c02d5f08a43baf22d6fcb95559ea8899602a5bd608502370f29912c0ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe91f85061fe54bf8939276aefec9126c9f2d3d9d46f17f32fcae0d798628a5c"
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
