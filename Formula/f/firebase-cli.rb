require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.9.0.tgz"
  sha256 "01bdc467c1d4704cacc56c74b498c2f9743c9c1972516b6692502eb27cf20c4b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dd146402a6c6055ee426c0326392e3d35054d9c44b379825649b1b43f52e1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dd146402a6c6055ee426c0326392e3d35054d9c44b379825649b1b43f52e1bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd146402a6c6055ee426c0326392e3d35054d9c44b379825649b1b43f52e1bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5265ce89d840db8472dec89290489447477c4eac6a3dfd6f5af990b42f1e169d"
    sha256 cellar: :any_skip_relocation, ventura:        "5265ce89d840db8472dec89290489447477c4eac6a3dfd6f5af990b42f1e169d"
    sha256 cellar: :any_skip_relocation, monterey:       "5265ce89d840db8472dec89290489447477c4eac6a3dfd6f5af990b42f1e169d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66348775abc75e12cb14509a2130af996ce4361e15dc915c67bfe730468bdbe4"
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
