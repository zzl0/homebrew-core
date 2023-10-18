class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.4.tgz"
  sha256 "ce91baadd5f9b0dda64ab97f76d34755ef20d37fbf5567ba0996b63bc4851579"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, ventura:        "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, monterey:       "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57cfde8b7d7d8bdcb72773a1bf72651c3633fe8802689b3354968fcbb14b42d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
