class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.219.0.tar.gz"
  sha256 "100458a3bc60c23fbc374748b7eab3f4666aa50fb84ffe94daa9e074d5dbf059"
  license "MIT"
  revision 1
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5e0413c4a77ea10e5c0dd51c4a7b95fb6e9b0a05721deea42de89aa3dacdfa50"
    sha256 cellar: :any,                 arm64_ventura:  "e9dcc2a41d4ed76fab9d725597898f074b3b23dada7e95624c86d2f2cd449976"
    sha256 cellar: :any,                 arm64_monterey: "29b15a7adec7e8d52796ffd7173f56a87eba3bd1b815a47e953ef6c21a9c1809"
    sha256 cellar: :any,                 sonoma:         "4d55ebd2b53f5b89dfd10123e16ebc2a849ff21da895195c7dd041c7cf17a068"
    sha256 cellar: :any,                 ventura:        "0b8a40f1456ba5b6225c7d8bccd1780f74481bd23a11f86263f190b8126bc06b"
    sha256 cellar: :any,                 monterey:       "d4405e8b7ac272967da58ba02a9f267ba1618c85f9413aa4933f5ce78e844047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da1de0978be5c3374b380b1a664b9a249042bfae872025f6215dc66827a75f47"
  end

  depends_on "ruby"

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
