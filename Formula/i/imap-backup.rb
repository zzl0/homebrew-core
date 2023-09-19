class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "2460f1f7f7761b95810bb9743264d5ccd37df808904fd255e14b21f7a4403955"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab6626cab9bd53f94bdb8ac115f141a99ce3ff63da1adaaf8dd4edac0f62eb89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab6626cab9bd53f94bdb8ac115f141a99ce3ff63da1adaaf8dd4edac0f62eb89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab6626cab9bd53f94bdb8ac115f141a99ce3ff63da1adaaf8dd4edac0f62eb89"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6626cab9bd53f94bdb8ac115f141a99ce3ff63da1adaaf8dd4edac0f62eb89"
    sha256 cellar: :any_skip_relocation, monterey:       "ab6626cab9bd53f94bdb8ac115f141a99ce3ff63da1adaaf8dd4edac0f62eb89"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab6626cab9bd53f94bdb8ac115f141a99ce3ff63da1adaaf8dd4edac0f62eb89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e246530e133c7b5161af4872f32491f084a4ed01c070fd6516fbaaf74bedb609"
  end

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "2\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end
