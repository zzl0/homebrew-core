require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.3.0.tgz"
  sha256 "78e26e2ad96d2b52beb6e9f1419be6e2d9fb1ebfa57a6f6b685f1c49a81c248d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6382b1304f94f9e665b2930cc12dcfaaf06d5908e969ec5744ef28ebba040d03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6382b1304f94f9e665b2930cc12dcfaaf06d5908e969ec5744ef28ebba040d03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6382b1304f94f9e665b2930cc12dcfaaf06d5908e969ec5744ef28ebba040d03"
    sha256 cellar: :any_skip_relocation, sonoma:         "22ca5c19ea9e06b7057bc94ce66da72f018ba7258696f6a39c62e4e028832e45"
    sha256 cellar: :any_skip_relocation, ventura:        "22ca5c19ea9e06b7057bc94ce66da72f018ba7258696f6a39c62e4e028832e45"
    sha256 cellar: :any_skip_relocation, monterey:       "22ca5c19ea9e06b7057bc94ce66da72f018ba7258696f6a39c62e4e028832e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247fa125e98c222d0f59498eacc100a5d5994668dbf8c1662b20211e4ac6c6da"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
