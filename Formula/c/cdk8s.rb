require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.157.0.tgz"
  sha256 "23857bf4db6839ac59396eb4f9784b6e10405abaaca7a72c4a7cdfde77566cc9"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57fd840c275f5c6de762274cf9567d09470e7f78d79c8408ff75b02cd45ea8ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57fd840c275f5c6de762274cf9567d09470e7f78d79c8408ff75b02cd45ea8ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57fd840c275f5c6de762274cf9567d09470e7f78d79c8408ff75b02cd45ea8ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "760556cceed8d8fbba87b135ccf3e83de774699ff6f9dd5c34d6fed4004067cb"
    sha256 cellar: :any_skip_relocation, ventura:        "760556cceed8d8fbba87b135ccf3e83de774699ff6f9dd5c34d6fed4004067cb"
    sha256 cellar: :any_skip_relocation, monterey:       "760556cceed8d8fbba87b135ccf3e83de774699ff6f9dd5c34d6fed4004067cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57fd840c275f5c6de762274cf9567d09470e7f78d79c8408ff75b02cd45ea8ec"
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
