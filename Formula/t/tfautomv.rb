class Tfautomv < Formula
  desc "Generate Terraform moved blocks automatically for painless refactoring"
  homepage "https://tfautomv.dev/"
  url "https://github.com/busser/tfautomv/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "10ee3f50f7444415fb1467996ca79c11be67a863cc839d7641cf49a9fef38bd5"
  license "Apache-2.0"
  head "https://github.com/busser/tfautomv.git", branch: "main"

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    tofu = Formula["opentofu"].opt_bin/"tofu"
    output = shell_output("#{bin}/tfautomv -terraform-bin #{tofu} -show-analysis 2>&1", 1)
    assert_match "No configuration files", output

    assert_match version.to_s, shell_output("#{bin}/tfautomv -version")
  end
end
