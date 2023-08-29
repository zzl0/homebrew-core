require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.73.tgz"
  sha256 "bb6aa7f80ca951d64f500a935cb7692641875f401ad60a4a37a4901aaf86fef8"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcf0304253c96a31240d8773fc8ee11b5ee2898e95a746a3228ce70661beefec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcf0304253c96a31240d8773fc8ee11b5ee2898e95a746a3228ce70661beefec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcf0304253c96a31240d8773fc8ee11b5ee2898e95a746a3228ce70661beefec"
    sha256 cellar: :any_skip_relocation, ventura:        "da9faf58595ac8017d2c453f39b9e945a81d1327c109dd02c5345a8642cadade"
    sha256 cellar: :any_skip_relocation, monterey:       "da9faf58595ac8017d2c453f39b9e945a81d1327c109dd02c5345a8642cadade"
    sha256 cellar: :any_skip_relocation, big_sur:        "da9faf58595ac8017d2c453f39b9e945a81d1327c109dd02c5345a8642cadade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf0304253c96a31240d8773fc8ee11b5ee2898e95a746a3228ce70661beefec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
