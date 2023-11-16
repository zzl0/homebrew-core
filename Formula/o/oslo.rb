class Oslo < Formula
  desc "CLI tool for the OpenSLO spec"
  homepage "https://openslo.com/"
  url "https://github.com/OpenSLO/oslo/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "ee43704402d8867e952bc02086da4ec175a405599ffe3ac654053e9245ff10f7"
  license "Apache-2.0"
  head "https://github.com/openslo/oslo.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"oslo", "completion")

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/definitions/slo.yaml"
    assert_match "Valid!", shell_output("#{bin}/oslo validate -f #{test_file}")

    output = shell_output("#{bin}/oslo convert -f #{test_file} -o nobl9 2>&1", 1)
    assert_match "the convert command is only supported for apiVersion 'openslo/v1'", output
  end
end
