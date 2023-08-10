class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "935601a9988a8e411725c74c7f60599d9ec7720c795e9656b6bd4e02c565a277"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cc80fc915b93c9eb0eb504ae9857052507748729795390c41c1de313bed2e9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc80fc915b93c9eb0eb504ae9857052507748729795390c41c1de313bed2e9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cc80fc915b93c9eb0eb504ae9857052507748729795390c41c1de313bed2e9d"
    sha256 cellar: :any_skip_relocation, ventura:        "50b4811dbbc6c5db0c96980e5ee659a078e4e3f07594c8ef893a3dea83605c0e"
    sha256 cellar: :any_skip_relocation, monterey:       "50b4811dbbc6c5db0c96980e5ee659a078e4e3f07594c8ef893a3dea83605c0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "50b4811dbbc6c5db0c96980e5ee659a078e4e3f07594c8ef893a3dea83605c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0d4f7ba52516a4e95e0db03541eb4d48ea98c921a5559582e0ca62b4f63942b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-oauth", 2)
  end
end
