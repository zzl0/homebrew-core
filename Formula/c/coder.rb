class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "a8d3e04707c9790d871fb5ca044f363aa5a16dc9f253e92042480dff4567ce17"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ad155d54f4b44f098ab2111ea981540c9fc14d55b5979b4bab2a545e7017edf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07f15129bf8900ca4d99d308f3dcb7e96d276a650f2dc9d34f6d7272d668ebbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38907772a8b65547fe9c98465065a8d8db8d6f80986850ab3e79182cb8e3520"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9850718b8575ff607980d311cab7b04544ef971159df151b7aa0f5f1789996e"
    sha256 cellar: :any_skip_relocation, ventura:        "5f7109d0c47abd9f71dda22b1f1f0eceb0f4049d251bca37c5d82f0e461468c1"
    sha256 cellar: :any_skip_relocation, monterey:       "51e2b68def998322ed938cbd4e32b5adbe49fcfd2caef98eef36de485347d5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e326e4fd8b330568fc090634f8c396b8f4facbd315535f20785eaa359bda04b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
