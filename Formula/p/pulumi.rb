class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.104.2",
      revision: "7bb2a3c2acec59d36411212d9cba7d3b1cc8f840"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "979a108c245855e58e406ea2113a465b81ca30045ac89ed8937f7dd7429d0d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afae5f4695f0cc308057ff36e80067fde8fb773af93f9b5935b1a620653eea98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "013903545ff804342abc63b0dd4558c10f082184e28b9b514b6c4f456dbdc731"
    sha256 cellar: :any_skip_relocation, sonoma:         "3529aa07cc894c925b8c9f362259949321682d85a2a6860ebecb82ec4e30338c"
    sha256 cellar: :any_skip_relocation, ventura:        "4e1933351e87c674eccf270390ee00f5ad869f11de99e77fb1327d47a9a0c3cf"
    sha256 cellar: :any_skip_relocation, monterey:       "a238b2c7dc26e519399744e844a27ad1e51842677bb7012deea1b2c7314d3952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9c1b75c75a301343ec387cdbc700bd5d8083bbfc23a147318a19d2fa51a873"
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
