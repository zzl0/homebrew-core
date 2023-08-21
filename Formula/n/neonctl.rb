require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.21.1.tgz"
  sha256 "5875c358b0de0c0fe02c51a9f97891064ed2210db0b2ad279aae056ad48fb3f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6efe9184a9e2a3896e8cf3b6bed2fbce627b8576bee6f4fc6ff3d05bcd3d32d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6efe9184a9e2a3896e8cf3b6bed2fbce627b8576bee6f4fc6ff3d05bcd3d32d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6efe9184a9e2a3896e8cf3b6bed2fbce627b8576bee6f4fc6ff3d05bcd3d32d2"
    sha256 cellar: :any_skip_relocation, ventura:        "a14618b719b12f06f2c2511990add80a37ac0c1322d5200df8fc6952c4f90673"
    sha256 cellar: :any_skip_relocation, monterey:       "a14618b719b12f06f2c2511990add80a37ac0c1322d5200df8fc6952c4f90673"
    sha256 cellar: :any_skip_relocation, big_sur:        "a14618b719b12f06f2c2511990add80a37ac0c1322d5200df8fc6952c4f90673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6efe9184a9e2a3896e8cf3b6bed2fbce627b8576bee6f4fc6ff3d05bcd3d32d2"
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
