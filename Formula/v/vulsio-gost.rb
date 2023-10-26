class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "2a76fb45307d2fd3f13fe3eff096b91f1b669dd18c6a0dc02a6951764d61c0e7"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"gost", ldflags: ldflags)

    generate_completions_from_executable(bin/"gost", "completion", base_name: "gost")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
