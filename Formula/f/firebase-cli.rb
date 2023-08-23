require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.5.1.tgz"
  sha256 "43bb7e87e7a3e2e17f3294504f6c2b4d6d71c92e07825bb46d332e22da6cd67d"
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
