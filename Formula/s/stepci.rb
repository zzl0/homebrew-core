require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.7.0.tgz"
  sha256 "6744878bfbe87c040d79c16b699a220d92dfa00071e31f2871c6b81181408947"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd111cbb4a487f45f8e7102c57bdab2d408f218a4e56fac1abdf1fafa4005d86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd111cbb4a487f45f8e7102c57bdab2d408f218a4e56fac1abdf1fafa4005d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd111cbb4a487f45f8e7102c57bdab2d408f218a4e56fac1abdf1fafa4005d86"
    sha256 cellar: :any_skip_relocation, sonoma:         "c063ab01d738d31d1ea07e84b24e01dbdb2d1ec2028932db7c375827e05598d3"
    sha256 cellar: :any_skip_relocation, ventura:        "c063ab01d738d31d1ea07e84b24e01dbdb2d1ec2028932db7c375827e05598d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c063ab01d738d31d1ea07e84b24e01dbdb2d1ec2028932db7c375827e05598d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd111cbb4a487f45f8e7102c57bdab2d408f218a4e56fac1abdf1fafa4005d86"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://docs.stepci.com/legal/privacy.html
    ENV["STEPCI_DISABLE_ANALYTICS"] = "1"

    (testpath/"workflow.yml").write <<~EOS
      version: "1.1"
      name: Status Check
      env:
        host: example.com
      tests:
        example:
          steps:
            - name: GET request
              http:
                url: https://${{env.host}}
                method: GET
                check:
                  status: /^20/
    EOS

    expected = <<~EOS
      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end
