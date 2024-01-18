require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.1.tgz"
  sha256 "8e73a052114fe94c8553a13acaee6fbe78d8aef40977ee329b1bc4265fbb89b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0684420e3dfb189814c8cb389940ea955f43b26ab57d3fec39856e3ba7c97d62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0684420e3dfb189814c8cb389940ea955f43b26ab57d3fec39856e3ba7c97d62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0684420e3dfb189814c8cb389940ea955f43b26ab57d3fec39856e3ba7c97d62"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fe48eaff0d6e6b24bd45727e2fea5ab5a62ef52e8ede5cd5705f82b22caf6a9"
    sha256 cellar: :any_skip_relocation, ventura:        "3fe48eaff0d6e6b24bd45727e2fea5ab5a62ef52e8ede5cd5705f82b22caf6a9"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe48eaff0d6e6b24bd45727e2fea5ab5a62ef52e8ede5cd5705f82b22caf6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2e53e43150bc075897977a0dc00c913befc42ecea7c51d9b14c099935767e5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~EOS
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    EOS

    expected_dbml = <<~EOS
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
