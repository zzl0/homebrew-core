require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-17.0.7.tgz"
  sha256 "6d0b9ae677e8c427d9f7d1fe214365bf818d24375b1ed1e2cab8375287184730"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3496537ce219910c28a5961f0ac8ff94a70eed8406e2a92e8b289f886894e38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3496537ce219910c28a5961f0ac8ff94a70eed8406e2a92e8b289f886894e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3496537ce219910c28a5961f0ac8ff94a70eed8406e2a92e8b289f886894e38"
    sha256 cellar: :any_skip_relocation, sonoma:         "352d7a80a111b2ab792bd22111b2f11ac9c70a289a2ee26edbb357cbe641314d"
    sha256 cellar: :any_skip_relocation, ventura:        "352d7a80a111b2ab792bd22111b2f11ac9c70a289a2ee26edbb357cbe641314d"
    sha256 cellar: :any_skip_relocation, monterey:       "352d7a80a111b2ab792bd22111b2f11ac9c70a289a2ee26edbb357cbe641314d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3496537ce219910c28a5961f0ac8ff94a70eed8406e2a92e8b289f886894e38"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end
