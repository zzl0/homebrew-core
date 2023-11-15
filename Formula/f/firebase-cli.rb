require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.9.0.tgz"
  sha256 "01bdc467c1d4704cacc56c74b498c2f9743c9c1972516b6692502eb27cf20c4b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34cad4ce0cff44383b8a0608fba3346a091e2ac70e287a3c81a0d456a99d8c9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34cad4ce0cff44383b8a0608fba3346a091e2ac70e287a3c81a0d456a99d8c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34cad4ce0cff44383b8a0608fba3346a091e2ac70e287a3c81a0d456a99d8c9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "84fa7c53ea734e97347bd2c7d6d8383b713ac1cd0cd0e2d6d638518b81486c6f"
    sha256 cellar: :any_skip_relocation, ventura:        "84fa7c53ea734e97347bd2c7d6d8383b713ac1cd0cd0e2d6d638518b81486c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "84fa7c53ea734e97347bd2c7d6d8383b713ac1cd0cd0e2d6d638518b81486c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0358a224376f6cc6ec82fd5ea3c0cf255fa4582a0d68b71cf34abe4398a6e166"
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
