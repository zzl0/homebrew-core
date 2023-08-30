class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/4.8.1/bazel-diff_deploy.jar"
  sha256 "1a7afe747558a217670a60f51f4d0d5bd3a99cb843f9abd4db6b5af9a4920dc1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "957e6fcf470797b9c94bb75462983cda08e09d47304736b9e3aa4ccd66a87eff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "957e6fcf470797b9c94bb75462983cda08e09d47304736b9e3aa4ccd66a87eff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "957e6fcf470797b9c94bb75462983cda08e09d47304736b9e3aa4ccd66a87eff"
    sha256 cellar: :any_skip_relocation, ventura:        "957e6fcf470797b9c94bb75462983cda08e09d47304736b9e3aa4ccd66a87eff"
    sha256 cellar: :any_skip_relocation, monterey:       "957e6fcf470797b9c94bb75462983cda08e09d47304736b9e3aa4ccd66a87eff"
    sha256 cellar: :any_skip_relocation, big_sur:        "957e6fcf470797b9c94bb75462983cda08e09d47304736b9e3aa4ccd66a87eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab4d17dd5a9ca64e2e0f7dbb63b15534932e9343baf38962c5b179bb13a603f9"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "Unexpected error during generation of hashes", output
  end
end
