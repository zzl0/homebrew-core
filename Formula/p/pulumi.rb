class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.103.0",
      revision: "7309681b5b8276c31c18599e8b37cffd7bc30783"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d55f79b7cdd618916491eae7fe24ca18b3bca70e342a2dd03c3f7ad193d8c87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fe1bbe91d188b5309fb872ef742a34afa9665ddc08e408efbd860da9694029b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d096ed888033ce7006cab96d71f124b836e4fe0393193ae6a2293ac0b8873f"
    sha256 cellar: :any_skip_relocation, sonoma:         "06a9b3361f05bf3ae39c9b3fa4b93d30d936404d6cf9843ad5d5a04c61f458c5"
    sha256 cellar: :any_skip_relocation, ventura:        "058b2b4d96db0ae64ed71c6f9b416c934b0c37b7ff884910dbd43f026a70d13b"
    sha256 cellar: :any_skip_relocation, monterey:       "facc85f1af58a215f142cfe0a305b7f44981c721e03c5e47fbfab1985c552562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7bbf8377245b34f1cc5b0c351b5878bf025e5d37ca7a26e4d36b234dc681971"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
