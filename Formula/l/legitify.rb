class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3095524885e073954d0d9b89bf468a69c8e2bebf982cdfbed50f06d7964263a6"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
