class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  stable do
    url "https://github.com/anchore/syft/archive/refs/tags/v0.95.0.tar.gz"
    sha256 "bdf4866ee53ac0209b0b8768a147e9c79bfcc6e1c788a421f84ede8a7aa4f7bc"

    # fix `identify cyclone-json without $schema` issue
    patch do
      url "https://github.com/anchore/syft/commit/d91c2dd84211d825012063f78793787e7cbf2078.patch?full_index=1"
      sha256 "51abff0cf89bdf75dfea1ddcfce9d7d28c919cdf76a3d83bcb756b4b3c951f14"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f07b024384b7a81b701f57a9c1b76ab649093df5158e9d48d2d85979efa3b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28b816993795f48004c314385c5c410a9b4b3c360d606df9e624eb5ef524aa2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb9176956ef1ca3cd73764e1e61ac98150dead5b6f9a61282c057264fc3a609d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b622c44e4fab1617205469778efe8b42de6a4452d9dabe45d0447572d7b1f99a"
    sha256 cellar: :any_skip_relocation, ventura:        "01674b7181c37d3dce76cf137f65e156596fe1cc28c8983532e3dd330e323073"
    sha256 cellar: :any_skip_relocation, monterey:       "61cf0527ec4ff2ae793e80e6999c8677bd2d73c47d5735ac381739eabc5af7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d056b1f7db215654c83d612cca404cb4bb703cf2bce4110ea16045d77ca64b48"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
