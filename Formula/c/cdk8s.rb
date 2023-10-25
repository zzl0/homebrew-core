require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.156.0.tgz"
  sha256 "e1244a75dea50b433e566222a3e676e7deeea23ef4fc3357c2eaf2373cadc6a4"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a6e9b33abce8a99f7b6f7824b9b7c5e0c52d9158dd36df19fbc469a236d4d74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a6e9b33abce8a99f7b6f7824b9b7c5e0c52d9158dd36df19fbc469a236d4d74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6e9b33abce8a99f7b6f7824b9b7c5e0c52d9158dd36df19fbc469a236d4d74"
    sha256 cellar: :any_skip_relocation, sonoma:         "4456395041700d59636f77e088db9326f7b916252f400a31c47cbc3b5d289b9b"
    sha256 cellar: :any_skip_relocation, ventura:        "4456395041700d59636f77e088db9326f7b916252f400a31c47cbc3b5d289b9b"
    sha256 cellar: :any_skip_relocation, monterey:       "4456395041700d59636f77e088db9326f7b916252f400a31c47cbc3b5d289b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6e9b33abce8a99f7b6f7824b9b7c5e0c52d9158dd36df19fbc469a236d4d74"
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
