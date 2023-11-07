require "language/node"

class Graphqlviz < Formula
  desc "GraphQL Server schema visualizer"
  homepage "https://github.com/sheerun/graphqlviz"
  url "https://registry.npmjs.org/graphqlviz/-/graphqlviz-4.0.1.tgz"
  sha256 "1ede0553fe61ca6f59876b31a7d86f8f9aa692456255c1acf91c204feb2e1ef3"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.graphql"
    test_file.write <<~EOS
      type Query {
        hello: String
      }
    EOS

    output = pipe_output("#{bin}/graphqlviz", test_file.read)
    assert_match "digraph erd", output
    assert_match version.to_s, shell_output("#{bin}/graphqlviz --version")
  end
end
