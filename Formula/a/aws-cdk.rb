require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.107.0.tgz"
  sha256 "db475e60de5ccd11c8c56f8babf863f6916470c7ba0933e92bd875d0f3a73062"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d7c923ac76a40d548d07fad4ce09671319d02d621835d888f0d3fcbeae545a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d7c923ac76a40d548d07fad4ce09671319d02d621835d888f0d3fcbeae545a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d7c923ac76a40d548d07fad4ce09671319d02d621835d888f0d3fcbeae545a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5158117f8d588694da7f29464c4d89a0e306a4ca541c78020408578c87813e7"
    sha256 cellar: :any_skip_relocation, ventura:        "f5158117f8d588694da7f29464c4d89a0e306a4ca541c78020408578c87813e7"
    sha256 cellar: :any_skip_relocation, monterey:       "f5158117f8d588694da7f29464c4d89a0e306a4ca541c78020408578c87813e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "058ecd13be40e091b02ed40dd3b9d1eeff1f264e63cd5c0b457f41053f38ccc0"
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
