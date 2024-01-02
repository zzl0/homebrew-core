class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.19.2.tar.gz"
  sha256 "6441dc33f087cd293c5dc9c953954116a40ccb251d25a23268f04e5aded084e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80a4afcff33700016c2c72336d989de79ab935e6082fd5d066a6b3c9712123bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb3b04f6650c21283e3b16981b430c7bbf077bbdc1f0c6148e3eda782a7d4504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9595f617348e71b29923013ee724805d7e4c8c269d8e2e1ebea3511721eab817"
    sha256 cellar: :any_skip_relocation, sonoma:         "c58bb76b72f6b89e79647f5675cd6e1377fd4e2e65ab4a23d29195d70c13d506"
    sha256 cellar: :any_skip_relocation, ventura:        "12fb824d9c6089e36a6ae8112ff44bfbf65aa2952aa0d6469d9f7f13bbd6ac49"
    sha256 cellar: :any_skip_relocation, monterey:       "748748a64e48f076e9ccdb72b176152b0219670dce83773ee9a9d3b2cea6904f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f778d68461e8669b072729a8a0f896b32216db7c816b53f1401a50cb2f51a32a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
