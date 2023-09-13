require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.96.0.tgz"
  sha256 "09dbfc37dbe6061ee0333168047f80077988207d11b606111033c8a8987091d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5cfd486b561a0d5818900cd073f6ae9349a41df5a5f76719b925303466a0f60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5cfd486b561a0d5818900cd073f6ae9349a41df5a5f76719b925303466a0f60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5cfd486b561a0d5818900cd073f6ae9349a41df5a5f76719b925303466a0f60"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5f961913a76963dd29db7ef948effaec5bd5b9a9fb854a3b2885020cf79bfc"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5f961913a76963dd29db7ef948effaec5bd5b9a9fb854a3b2885020cf79bfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f5f961913a76963dd29db7ef948effaec5bd5b9a9fb854a3b2885020cf79bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acaf2177ab54238cb09c076e9d77d0381bd02101bb7ed65f02ea26e9adc1bc31"
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
