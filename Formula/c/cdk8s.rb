require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.4.tgz"
  sha256 "4980fb1fab6b3671fc9a4d0bfeab581fce58856921a46cfe16314cfd1b0f34d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "681df90bd6f87660a06060f5ee8d6a08c73b2222339c541b6176bbb243f1eb47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "681df90bd6f87660a06060f5ee8d6a08c73b2222339c541b6176bbb243f1eb47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "681df90bd6f87660a06060f5ee8d6a08c73b2222339c541b6176bbb243f1eb47"
    sha256 cellar: :any_skip_relocation, sonoma:         "6964ed108dd6b0621e553ffc89010f31dccd01411dbdd0c2c8ec258b37bc1f62"
    sha256 cellar: :any_skip_relocation, ventura:        "6964ed108dd6b0621e553ffc89010f31dccd01411dbdd0c2c8ec258b37bc1f62"
    sha256 cellar: :any_skip_relocation, monterey:       "6964ed108dd6b0621e553ffc89010f31dccd01411dbdd0c2c8ec258b37bc1f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681df90bd6f87660a06060f5ee8d6a08c73b2222339c541b6176bbb243f1eb47"
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
