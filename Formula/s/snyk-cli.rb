require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1273.0.tgz"
  sha256 "2613465b9a4faeb6df4653f9f4baaf2b0c15701ec1c047f41f60a84f6933a00e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbafb11b2019c0b8e643beab97eb09ecdc601ddfa5aacf7199e7a983329dcb76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "858fe12fed7e1b1ca3a97cf819f5e4a189973d2893216bb9bc6dffde248ae307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "528060be4041a235932f90a609071b2bf43301df4c2c25c12831a12146fd6500"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3a1b68c8e8b243e0484f519acae66d452c54e4428a1eeea28b0cc2173f5a217"
    sha256 cellar: :any_skip_relocation, ventura:        "b91db304363163d168e67ca87773ce1eaba908c323c630bb272eaf37e8055919"
    sha256 cellar: :any_skip_relocation, monterey:       "af16ed1b583cf92717879691cb51d4a11f2915c032fe1e8a506a5503c7343aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732cdd1dda6d8d0c965388e4d6495bf04a53b68e15e563ff34bb39bf571bf131"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
