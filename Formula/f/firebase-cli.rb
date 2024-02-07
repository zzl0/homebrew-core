require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.2.1.tgz"
  sha256 "68890c75c2453d6708c59c0189df316a09e238155f4e6c7eeeedc7d05db9dcdb"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b500a42fcd7ba491ba259fabcbf5f7498d6c2380268b066562b92e88520c2844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b500a42fcd7ba491ba259fabcbf5f7498d6c2380268b066562b92e88520c2844"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b500a42fcd7ba491ba259fabcbf5f7498d6c2380268b066562b92e88520c2844"
    sha256 cellar: :any_skip_relocation, sonoma:         "04576b3b46648a3011b97a5792a98b113a84d8427220113593ebca117308408d"
    sha256 cellar: :any_skip_relocation, ventura:        "04576b3b46648a3011b97a5792a98b113a84d8427220113593ebca117308408d"
    sha256 cellar: :any_skip_relocation, monterey:       "04576b3b46648a3011b97a5792a98b113a84d8427220113593ebca117308408d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5b7d33bbed55c267384c85e83f3b4b1999d0aad8492e5b6532a7a1f9809cb3"
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
