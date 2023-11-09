class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.25.0.tar.gz"
  sha256 "106388473c8dc627bbee53a5b5f42c1b3792e85d0b491ba5a18ced45c3b52aa0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "616bc7eb2fb86ca2061721da82c0bd23af588e60efc82373de9ff0823b38cb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "071ca79c63d511233b50fb67ebba5a5a0d6400b39e19c104a9fb69b2b9a1c21c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "516b61d4f7999ac13c6e03d148b53c3d0c0ac2792cad04c9faba5e464fe80f13"
    sha256 cellar: :any_skip_relocation, sonoma:         "2af7467cb3755bd13dcefbd00919039e1ebfbe8356eb35d16188b182f3a19fcb"
    sha256 cellar: :any_skip_relocation, ventura:        "d72543db6d9c551beeea8de56fa82c4cec184bd34670c082bdbc07cae3b29044"
    sha256 cellar: :any_skip_relocation, monterey:       "dde475ff0dc8c578cf51b160d62c5880388c2123ac7bce67aff5aa39920364be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c814832bded3a17c846225efba304f033bdd9c7b8e6467897c02df34a4966b70"
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
