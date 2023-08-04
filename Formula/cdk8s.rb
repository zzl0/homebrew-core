require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.19.0.tgz"
  sha256 "3ed8aa552a2587d6c8b3b6dec66a67318aaa405f7d6e6b82cc9500ce63477cc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75f833c3b163125b397b3fd1a6f70dd04f8d51ad78cf09dc4e27b2ec22a1c3e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f833c3b163125b397b3fd1a6f70dd04f8d51ad78cf09dc4e27b2ec22a1c3e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75f833c3b163125b397b3fd1a6f70dd04f8d51ad78cf09dc4e27b2ec22a1c3e4"
    sha256 cellar: :any_skip_relocation, ventura:        "398e7826b3017e7d0248aded9d69a68741d98d4630771a554313296c4ac2949b"
    sha256 cellar: :any_skip_relocation, monterey:       "398e7826b3017e7d0248aded9d69a68741d98d4630771a554313296c4ac2949b"
    sha256 cellar: :any_skip_relocation, big_sur:        "398e7826b3017e7d0248aded9d69a68741d98d4630771a554313296c4ac2949b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65aae5131d67512d01daf4f48e3522cdccad7704a8af53bd5818ecbd0ab9657"
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
