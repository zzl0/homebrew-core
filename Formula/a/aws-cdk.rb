require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.121.0.tgz"
  sha256 "c0bea8966ca6196eac3185507955e8617fa180ebc65e1e8d1dbe3325b52f6da0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "380480dbe50e53dfd1ede9e48288f6075840b77a09a1512585098772be8a0753"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "380480dbe50e53dfd1ede9e48288f6075840b77a09a1512585098772be8a0753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "380480dbe50e53dfd1ede9e48288f6075840b77a09a1512585098772be8a0753"
    sha256 cellar: :any_skip_relocation, sonoma:         "d36077fb39a1d48e79c1e6b470049e6f2d94bb412a4db08adbb4a92f21d8617f"
    sha256 cellar: :any_skip_relocation, ventura:        "d36077fb39a1d48e79c1e6b470049e6f2d94bb412a4db08adbb4a92f21d8617f"
    sha256 cellar: :any_skip_relocation, monterey:       "d36077fb39a1d48e79c1e6b470049e6f2d94bb412a4db08adbb4a92f21d8617f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9aff7a55e5e4905ee757f27418ee0690ffa419b871a41eeedc94d905cff0217"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
