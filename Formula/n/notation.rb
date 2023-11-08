class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f3f9df6fbd717cc169030d6527591d56fd37f0469a4a3b4c4e3d4c1ee0264299"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b967a2f4c05b38392b9a589371ed1d48315b877de2aa22c7f09876161d1aed76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95356462886bde10123d40640a23a135bd059ab77d92add6a0cc7442ee32379f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d93eaf9dffeba4f93a98ec1b7e42d0d17fe779215afe301dbe5cec7dd301381f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7b03137db89f3c8457e7eabf24fb3db1cd9f377867f9e168547de5eb621bd05"
    sha256 cellar: :any_skip_relocation, ventura:        "6d115251f1f18f2b4746224ced357fbd74efecad21b57cf67e490d2b745a6d9f"
    sha256 cellar: :any_skip_relocation, monterey:       "456df15807ea7ec10a5a6bafb089cb39f32a1fda1f14107d0447e5d4aab64bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e251f61207de5067228fc4bfe045711953f983419feae855394bbf24eb48d371"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=
      -X #{project}/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/notation"

    generate_completions_from_executable(bin/"notation", "completion")
  end

  test do
    assert_match "v#{version}+Homebrew", shell_output("#{bin}/notation version")

    assert_match "Successfully added #{tap.user}.crt to named store #{tap.user} of type ca",
      shell_output("#{bin}/notation cert generate-test --default '#{tap.user}'").strip
  end
end
