require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.25.1.tgz"
  sha256 "47733467ea4d592f2a5bfee3e6fea35ea66c6af07222988ed0441440cffbe78c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5df06be1d6672ea7bd19784874abcc1fde90602e7875b36fc04b4dd699197ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5df06be1d6672ea7bd19784874abcc1fde90602e7875b36fc04b4dd699197ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5df06be1d6672ea7bd19784874abcc1fde90602e7875b36fc04b4dd699197ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5876d6dd35837a82488811c853560b49cfdb64729ce10b0b2d3752602ec27e5"
    sha256 cellar: :any_skip_relocation, ventura:        "e5876d6dd35837a82488811c853560b49cfdb64729ce10b0b2d3752602ec27e5"
    sha256 cellar: :any_skip_relocation, monterey:       "e5876d6dd35837a82488811c853560b49cfdb64729ce10b0b2d3752602ec27e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5df06be1d6672ea7bd19784874abcc1fde90602e7875b36fc04b4dd699197ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
