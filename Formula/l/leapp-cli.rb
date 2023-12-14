require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.54.tgz"
  sha256 "52f5590ff097ea27814c8eac762b5d30e447a560bed68ab75f95635079d7c1c9"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "be7b8d716fe6ba4ef9b2e0f8991776f924cd2647a5bf300c28efd38a481671a9"
    sha256                               arm64_ventura:  "5ab49ae2b4f0a3b38b1dccc5ee0121b0f2aab6d0c12a63af63abeae3df652566"
    sha256                               arm64_monterey: "9cb56f1b0ac0581022f0c600af84dd45ed6b986d27416488b21c3178b3ba5141"
    sha256                               sonoma:         "97696274cf47664c8e4c420db85704a634784336c1ad0e1630121dd027ad258e"
    sha256                               ventura:        "00d239355bf7781252def717f795713d35fcf6658ca7e9ad47fee33303d6cb61"
    sha256                               monterey:       "9c57528340a0da7b7d56f4d28a6ab12b8c1bf0e54fc2c150d65a93c22ea5dae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a851a0034f5f922480b157d690aa2460f2cd7094c12dad1eec1d4e2d9e3d2cc5"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
