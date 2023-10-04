require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.6.2.tgz"
  sha256 "64f62b8e11458ba770ef4850777c6b263b2c6a52751da800a5a6cfc2d1e8e530"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc2a5b4cbf523f53805e87b3bb150219a1f2f11c257e91b2f2c29407a7fb837a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc2a5b4cbf523f53805e87b3bb150219a1f2f11c257e91b2f2c29407a7fb837a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc2a5b4cbf523f53805e87b3bb150219a1f2f11c257e91b2f2c29407a7fb837a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7955d4d91a62ab7513ace8dd8fcdcf76521692cb11f8a23457ba18949c1bcd31"
    sha256 cellar: :any_skip_relocation, ventura:        "7955d4d91a62ab7513ace8dd8fcdcf76521692cb11f8a23457ba18949c1bcd31"
    sha256 cellar: :any_skip_relocation, monterey:       "7955d4d91a62ab7513ace8dd8fcdcf76521692cb11f8a23457ba18949c1bcd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acb99086c304576530416940a8423ed474623ff6db46bd4e05e9758863e8b8a2"
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
