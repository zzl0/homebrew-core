require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.182.0.tgz"
  sha256 "38242b599b803d710936625973beca1eff91f16c0cab5aca85ad064b51b21811"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f16b7ab9f70bc2e80797ac5bea83bc240567ae2e53e5b9ec23821ad9fc31a501"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f16b7ab9f70bc2e80797ac5bea83bc240567ae2e53e5b9ec23821ad9fc31a501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f16b7ab9f70bc2e80797ac5bea83bc240567ae2e53e5b9ec23821ad9fc31a501"
    sha256 cellar: :any_skip_relocation, sonoma:         "1893997d342ca6386cd9076ad61d66a51cebd6463cf48d3581edb077f32428cb"
    sha256 cellar: :any_skip_relocation, ventura:        "1893997d342ca6386cd9076ad61d66a51cebd6463cf48d3581edb077f32428cb"
    sha256 cellar: :any_skip_relocation, monterey:       "1893997d342ca6386cd9076ad61d66a51cebd6463cf48d3581edb077f32428cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f16b7ab9f70bc2e80797ac5bea83bc240567ae2e53e5b9ec23821ad9fc31a501"
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
