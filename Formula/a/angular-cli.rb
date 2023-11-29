require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.4.tgz"
  sha256 "dab83f0f248307f39362e7ce168711df3f04e4eac95f07ea4c5f58c8e7ca2846"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3687f60ef2a0cb28011d40dc051a6377cab5d632733c5fe8ba8f6800478b7de8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3687f60ef2a0cb28011d40dc051a6377cab5d632733c5fe8ba8f6800478b7de8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3687f60ef2a0cb28011d40dc051a6377cab5d632733c5fe8ba8f6800478b7de8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7334ea946137ffa5307e912f2754e6e21e8e7a235ae5c04a2d891cb456c648dc"
    sha256 cellar: :any_skip_relocation, ventura:        "7334ea946137ffa5307e912f2754e6e21e8e7a235ae5c04a2d891cb456c648dc"
    sha256 cellar: :any_skip_relocation, monterey:       "7334ea946137ffa5307e912f2754e6e21e8e7a235ae5c04a2d891cb456c648dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3687f60ef2a0cb28011d40dc051a6377cab5d632733c5fe8ba8f6800478b7de8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
