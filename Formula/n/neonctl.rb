require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.26.0.tgz"
  sha256 "1ea17c9d5b46116eccc633a78c6f57ef6dc7954eeb599c044112c03d11a300d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e108a69f23e5d49a2b9e1964cca96387b3486f7207f55f3af3350b82676fa814"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e108a69f23e5d49a2b9e1964cca96387b3486f7207f55f3af3350b82676fa814"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e108a69f23e5d49a2b9e1964cca96387b3486f7207f55f3af3350b82676fa814"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b1f6d0385582c05eb8c07ab8bfddbba501aaaa3323cb3842323434840aaf624"
    sha256 cellar: :any_skip_relocation, ventura:        "3b1f6d0385582c05eb8c07ab8bfddbba501aaaa3323cb3842323434840aaf624"
    sha256 cellar: :any_skip_relocation, monterey:       "3b1f6d0385582c05eb8c07ab8bfddbba501aaaa3323cb3842323434840aaf624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e108a69f23e5d49a2b9e1964cca96387b3486f7207f55f3af3350b82676fa814"
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
