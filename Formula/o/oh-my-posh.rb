class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.21.1.tar.gz"
  sha256 "5c12106810eed22b636d8768c4b3ef4a497835e9ddeef90414f831473ff67f7a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98e9fcadc85e35a673131580fa3d07d4c3c25c889565f83963b4814b41bdb7d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a8f8a45a524b7aab70f163037d65ab3cd63f6aef5bc387a3be93b29e7d54dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215fbe866d143a446f5f3b14cacf9cc9530100358190387e0451b40d0beba011"
    sha256 cellar: :any_skip_relocation, sonoma:         "a51676f778c75a6eca6ca7066eb23a1ea15140ecea51d1a0f8b66f120c15c1ef"
    sha256 cellar: :any_skip_relocation, ventura:        "baab960c1b1887848c18194892af7c1239992ac856c412d4d47e5352799d0e97"
    sha256 cellar: :any_skip_relocation, monterey:       "3d4ffbf508272effd283386575be7304733a7192d5b918e446ed705d5d156d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceafae94f838b1377288f0b51deeeb4938611ad2f4a4e012e4e0e274d4a96a37"
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
