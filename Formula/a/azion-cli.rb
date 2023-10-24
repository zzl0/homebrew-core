class AzionCli < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion-cli"
  url "https://github.com/aziontech/azion-cli/archive/refs/tags/1.5.1.tar.gz"
  sha256 "05b60ba56ea72b35feb28e91e17b3c9fc5eefdee8e65eb2abf9ac087b61c1d07"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
    ]
    system "go", "build", *std_go_args(output: bin/"azion", ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion", base_name: "azion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end
