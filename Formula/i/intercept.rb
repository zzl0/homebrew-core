class Intercept < Formula
  desc "Static Application Security Testing (SAST) tool"
  homepage "https://intercept.cc"
  url "https://github.com/xfhg/intercept/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9670a5cd43407cf26cc19fd0d0c9fef6f2ac2b46b4bd69b999b3932259e86020"
  license "AGPL-3.0-only"
  head "https://github.com/xfhg/intercept.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"intercept", "completion")

    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples", testpath

    output = shell_output("#{bin}/intercept config -r")
    assert_match "Config clear", output

    output = shell_output("#{bin}/intercept config -a examples/policy/minimal.yaml")
    assert_match "New Config created", output
  end
end
