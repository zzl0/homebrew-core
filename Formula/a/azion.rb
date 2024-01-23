class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.10.4.tar.gz"
  sha256 "f074b082947d11dd2b91b9671e61092982cb22da405216e52c2528a54832dcfe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fda1b887935a08bae3adf62ad3d60d72702d1da377589e26486f7811d4765048"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "295507083c3290ea72a839075e88818f6fcd6d84bf7ee7d51462983f104f72e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48a91c75d542709d260ce3a2239bbce60d11c0327841cb05cc22f702284a4c86"
    sha256 cellar: :any_skip_relocation, sonoma:         "c016bff122e977d6c88243acd84ad130858d6a79a00231d2b4ebf670e0fd8c9e"
    sha256 cellar: :any_skip_relocation, ventura:        "2e7346a090bf51f6dcd9ecef2dc759033df66b4aeb5c91e71a8b9e1a3134a491"
    sha256 cellar: :any_skip_relocation, monterey:       "dea54445ebca6fcba8b707f611db3b7dd39ffd232fa3c13ab6f23e8078ac9773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f929b1931ac3e7b779d146cda1bb3512ca8a151fa91341ce6d44acfd8fdccb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end
