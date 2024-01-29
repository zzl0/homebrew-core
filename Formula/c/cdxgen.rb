require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.0.0.tgz"
  sha256 "02e68515bbb4aa2c49febd3cf3a706d0eba744641b1fd2748d0fd9bdaec3b677"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd1032bff8064dbbbd652dadcc699e3ec0d1999508065d3737369b2da7b7f032"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ef62cb9bc2ecb0bc830151a550280655bc3077212cf0756f93c0ddae86a32d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c798494066e5b8caf8da9d1aef7469a039f63de275af5726f7d4169e2c625479"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe5d3bfb638767218ac3428215c44b10939b878b82575380d414f9f0b508d9c6"
    sha256 cellar: :any_skip_relocation, ventura:        "6cfc82c4496bef5bd254316de78569ab7f4be812a84c292bbae01bc3f27d4fee"
    sha256 cellar: :any_skip_relocation, monterey:       "9b091ed41d21db8dafd17d23ffeca88f66e8285c61147679ecef508eb4a13e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f57c4335ee5b9ca20e91ada4de64c3bd78a0f25280e707877a8f5371ecb7036"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins"
    cdxgen_plugins.glob("*/*").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
