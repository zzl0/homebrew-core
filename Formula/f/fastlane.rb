class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.215.0.tar.gz"
  sha256 "c92faba239e7cf6e7c0a7db5caf38b927e440e7598c22b850f8c5cc3f3744e0f"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "572611856ff7288cd46902f52766afa9244dec332b8f4674f89f37ab181d50ff"
    sha256 cellar: :any,                 arm64_monterey: "e4aea24c5b69f8009b37abb01f2f0978bbf2783ca37a7e97ca5beb1dac07457c"
    sha256 cellar: :any,                 arm64_big_sur:  "10dd8bad3c6e1a0e61e61b3ced89d8db67724037ca46f059e703068c28815cd0"
    sha256 cellar: :any,                 ventura:        "e7d9f6489dd6016f70a7cb0f664244cea03e1813c647ec7a10a20b8712076711"
    sha256 cellar: :any,                 monterey:       "4f5cd7de936f87722120acc8a72f1c3f39d98b515aa6c1d838b5ffef127a7020"
    sha256 cellar: :any,                 big_sur:        "23841838058921e1f58c098a42f3bd3d93ea9f5e29be65e65f7012ae1e270b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a422a0ac165cd326fdf7f5d8fd078c9025a45145bc9cae47ad5ac8fcaa9ff05"
  end

  depends_on "ruby@3.1"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby@3.1"].opt_bin}:#{libexec}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gems/terminal-notifier-*/vendor/terminal-notifier").first
    (terminal_notifier_dir/"terminal-notifier.app").rmtree

    if OS.mac?
      ln_sf(
        (Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
        terminal_notifier_dir,
      )
    end
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
