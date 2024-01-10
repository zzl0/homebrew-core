class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.101.1",
      revision: "c48ed3ba4989cc98ce14806ccf1c57c795757388"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b73cb6f85838b1e2391828a7e69edf381e49246204b5318ede589c1dd9374af3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3fd84e46857b8b8616d201b85bf2d6bcad083aef66718df6f50cbc5bd4e07df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e849d03ddf8b57df547a8347a937c7f7d4fe93c98b2d79ff1ffddae6d4f7b631"
    sha256 cellar: :any_skip_relocation, sonoma:         "713edfef472fa82c97aa7a966030df9a622ec032a00d790d018ca2577c32fc6a"
    sha256 cellar: :any_skip_relocation, ventura:        "305f91f2b6c3e7f3315257b0f0695077ea3a077a63e36326efcdd09c95091eaa"
    sha256 cellar: :any_skip_relocation, monterey:       "584493062a8f9b767b2fb2ce1ecc92e0a3e5fe15fa8ec793ba619b337761772e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a106c768118ef1a0acc1e7e533ae4f19f4e511b73f104239a3b7e6543494c34b"
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
