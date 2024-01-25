class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.73.2.tar.gz"
  sha256 "d916ec86ad41d437465d8dca352c3db809c64d14ce78077558a0ab61a11260d1"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb69968402a7df1674fdd619c2061cb59da50d68546c56a8e0e0e5c487ef319a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a738311f372e9cdc20063bbaec99ded309b07f6e014e02d253d3a2c4ba80ab39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ea589d504ca99430bfef7b77d6038cb97e89d3aff9abdcd1abf271b84e97210"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b43ca9ba2ced6fb792bc6b3edce572e817e575765cfb4744d63f4b066cf271a"
    sha256 cellar: :any_skip_relocation, ventura:        "48e3679277625bb93ea2bae70daf3af4d5c02ea2a97d40ef85ab17755bfb9e77"
    sha256 cellar: :any_skip_relocation, monterey:       "59aa840de2d462324389b18540fb17f1dcfcf9121c91ae84970fd03e117662f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d774ac30e14b0e72b0a3b81cd9cad75137345f07a7bc2b94cf37a426657e016b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
