class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9ae044bbb63a7a4d51fc561d946f6622505d43c219118ecaf3e275d97fb8ab97"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "./cmd/risor"

    generate_completions_from_executable(bin/"risor", "completion")
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)

    assert_match version.to_s, shell_output("#{bin}/risor version")
  end
end
