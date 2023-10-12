require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.7.0.tgz"
  sha256 "292916aa241501eb596e755346437a725408fa5d9c3d20551836934515524402"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "883610fce2924320eee62ee1c63d9c2e3b687dbc59a931fed20fa23c417c3f42"
    sha256                               arm64_ventura:  "af365a1cf2eb861a8b2398018830f9439def76663e30fead4c7d825c91c19700"
    sha256                               arm64_monterey: "7998b9504c40fbc1d14968dde1dc92d646442b5e575174696f8358d449a5eab7"
    sha256                               sonoma:         "9850094dc857b6f8ced6de678dd4d9de220c22915632aa4754b092ab2a4092e4"
    sha256                               ventura:        "b1d26b5e92802d6bed8afd3e7db7fa1015f90e4b55c1422194b551ebafd2f073"
    sha256                               monterey:       "5174d5960a91f1f9b4f1c4d27265f66aa6a1d3382c04694035ed1a7fce23e396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d3e3ee3e4122c6b872e750ba7a67ea3ef04bd723160ce2232c53bb24b0cd615"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
