require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.192.0.tgz"
  sha256 "f05c6e91858454ab98e7917dc286ef5fdb214599b38ee139ed76fe49b99cf83f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b8ba0151c31a1503d3b4a9b57ee59834c863d480a1fd23003a712bd87498440"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b8ba0151c31a1503d3b4a9b57ee59834c863d480a1fd23003a712bd87498440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b8ba0151c31a1503d3b4a9b57ee59834c863d480a1fd23003a712bd87498440"
    sha256 cellar: :any_skip_relocation, sonoma:         "430d2565fa64c8e08612eca3a1bf91007985e0724f45f3437ff5f08e7aa9c18c"
    sha256 cellar: :any_skip_relocation, ventura:        "430d2565fa64c8e08612eca3a1bf91007985e0724f45f3437ff5f08e7aa9c18c"
    sha256 cellar: :any_skip_relocation, monterey:       "430d2565fa64c8e08612eca3a1bf91007985e0724f45f3437ff5f08e7aa9c18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b8ba0151c31a1503d3b4a9b57ee59834c863d480a1fd23003a712bd87498440"
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
