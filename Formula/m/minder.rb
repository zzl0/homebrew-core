class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "664d26dc4d8bd4df248ba0f5a81f2b69398083cbc042fba80cbf0edb23245721"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 1)
    assert_match "Error on execute: error getting artifacts", output
  end
end
