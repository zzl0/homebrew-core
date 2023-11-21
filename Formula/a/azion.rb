class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.9.2.tar.gz"
  sha256 "8a4ab32e1a598e76c51625cb8bc3436ee2f1b736454e150209214c78a3fdb1ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fc86a9ed3777b1fe3126eb942b69fa3ce36ae167daf0427757901b29e796584"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92d1fa04c8825195b52c67ed8c3a58639b1752fe1d386d5e730595cbcc94f64a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36bb9484b7f57e78630215e20461ca327cd29fc0d7d1c38da94822df860c805d"
    sha256 cellar: :any_skip_relocation, sonoma:         "31c67299f91e09ad13db62dc9179791142a4de7d9ba802ad94db0d673dd36a6e"
    sha256 cellar: :any_skip_relocation, ventura:        "ab203fc93758c3a9938cf1d89d6e37c4a01540df2d5bf0c9e60f89933d9fe1d8"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c7352572440656470458e3f61283e6beb9531f86993e09790689aa9c9c48ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b17b87d23d7ee3b04044a260982746bf4a4abb6a313e1abcfc1f0f0e8b33fe88"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api/user/me
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
