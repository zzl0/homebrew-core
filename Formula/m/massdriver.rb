class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.6.tar.gz"
  sha256 "37ac198928a0583f9dd5c68f36c50e6c3b6ae15e42a8be01faf78d0be803e0fe"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1525f4a8230d84db83f471ec6eac252524a723053e343c02082657886e9a7008"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c123cbebf830f602e66647a0d9de143ef10028cbcd93b3ee2bcdb11548b3120c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4956185a040763a45aea3af7e58a9ec4da37d988f1f94190ebf25daa7142c8bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "832bfa722b556c7b08463604926ed1fc1c890fca38e63ed0f14cf52b64e83240"
    sha256 cellar: :any_skip_relocation, ventura:        "36d6b5bbd9197d7cb1623b803fa39396636dd0c5a4a2df310cc898dc105ff921"
    sha256 cellar: :any_skip_relocation, monterey:       "3ffb33a0a58fca848eaf20278f2b499b91e04bf71aa0b7d2f7e6a9470c41588f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f11788edaa8a198e80cc8fc8c902c253372afa80c13bf5f64d7f59cc9307124"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
