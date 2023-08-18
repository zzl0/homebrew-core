class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c7e3a154cb132d17c72c9954e2c2144b5dd1781af69e9bfe25ec29916e2f01be"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=#{tap.user}
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
