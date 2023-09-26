require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.98.0.tgz"
  sha256 "6f6c62e7dd234870da1cc581fc6d72253839b6fc9c87eeb0f9d239ffcfb0b0d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17f470efcc31a5941f76f831760221eb4d5c4709e0a1f8526c95882b27c62445"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17f470efcc31a5941f76f831760221eb4d5c4709e0a1f8526c95882b27c62445"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17f470efcc31a5941f76f831760221eb4d5c4709e0a1f8526c95882b27c62445"
    sha256 cellar: :any_skip_relocation, sonoma:         "2644d1bcbb7a14d0db47bccf6a106167fbee22e6ffc94943cb5557f523382470"
    sha256 cellar: :any_skip_relocation, ventura:        "2644d1bcbb7a14d0db47bccf6a106167fbee22e6ffc94943cb5557f523382470"
    sha256 cellar: :any_skip_relocation, monterey:       "2644d1bcbb7a14d0db47bccf6a106167fbee22e6ffc94943cb5557f523382470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364c2d84497a6f71eb30df28127130e8c648d1d2ab801e3ee951cd61ecb909d4"
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
