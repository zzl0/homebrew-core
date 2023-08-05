require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.21.0.tgz"
  sha256 "758da2219345cd046cd0268965dd79da8e4bba005984bb2ec152d935424426d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10a5a9165487630ee38775b1212a4e4bf43f9c091643e5e5e716093458b832b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a5a9165487630ee38775b1212a4e4bf43f9c091643e5e5e716093458b832b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10a5a9165487630ee38775b1212a4e4bf43f9c091643e5e5e716093458b832b0"
    sha256 cellar: :any_skip_relocation, ventura:        "574c6eddac1bb871faf491c51323aa5836e16d82218b39a81de4b96b63153f24"
    sha256 cellar: :any_skip_relocation, monterey:       "574c6eddac1bb871faf491c51323aa5836e16d82218b39a81de4b96b63153f24"
    sha256 cellar: :any_skip_relocation, big_sur:        "574c6eddac1bb871faf491c51323aa5836e16d82218b39a81de4b96b63153f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a895a19fb30eb232e1acf43ec289ebbb8cd78a8364ee7cc887e6776351780936"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
