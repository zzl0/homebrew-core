require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.0.tgz"
  sha256 "aeff48ae81b7959733e81656bc42a4902fafc7fbcf28f8b071b345c23cef3b40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
    sha256 cellar: :any_skip_relocation, ventura:        "c09ad4a394c65a2986072c1ff1f083bc31fa95c09a0837f4b12d5b8066773cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "c09ad4a394c65a2986072c1ff1f083bc31fa95c09a0837f4b12d5b8066773cdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c09ad4a394c65a2986072c1ff1f083bc31fa95c09a0837f4b12d5b8066773cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
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
