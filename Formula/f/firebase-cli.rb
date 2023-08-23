require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.5.0.tgz"
  sha256 "3a55c91c125bd5804a2da468017e1e073981f26c25e824210dd088709516aea5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "badb70a94002cbd8dd013f9292a6612f318a1e8be9cfd21250629cff8b13c972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "badb70a94002cbd8dd013f9292a6612f318a1e8be9cfd21250629cff8b13c972"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "badb70a94002cbd8dd013f9292a6612f318a1e8be9cfd21250629cff8b13c972"
    sha256 cellar: :any_skip_relocation, ventura:        "81126c0540541d01d7874428b2ac8fd5183dc356a087385e42a85a81f294bbbc"
    sha256 cellar: :any_skip_relocation, monterey:       "81126c0540541d01d7874428b2ac8fd5183dc356a087385e42a85a81f294bbbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "81126c0540541d01d7874428b2ac8fd5183dc356a087385e42a85a81f294bbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8119e8812c720afbdaafe09b7532395d74f84376269108377b178d26817145e8"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
