require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.116.0.tgz"
  sha256 "f50e5111ef8a9482f4871d08f532c7a743482acc7957ce521bc958c72a4ed64f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8546aaaff77a71fbb44f2315a26c8fa215f10f089a8af2e0f53a25b17efd0d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8546aaaff77a71fbb44f2315a26c8fa215f10f089a8af2e0f53a25b17efd0d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8546aaaff77a71fbb44f2315a26c8fa215f10f089a8af2e0f53a25b17efd0d9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1e4c22bc228773ed55f2b06d34d255db1e52579545838a1d1a60115762ddbbd"
    sha256 cellar: :any_skip_relocation, ventura:        "e1e4c22bc228773ed55f2b06d34d255db1e52579545838a1d1a60115762ddbbd"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e4c22bc228773ed55f2b06d34d255db1e52579545838a1d1a60115762ddbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8546aaaff77a71fbb44f2315a26c8fa215f10f089a8af2e0f53a25b17efd0d9e"
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
