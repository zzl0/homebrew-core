class Proxify < Formula
  desc "Portable proxy for capturing, manipulating, and replaying HTTP/HTTPS traffic"
  homepage "https://github.com/projectdiscovery/proxify"
  url "https://github.com/projectdiscovery/proxify/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "ed58d5e2cf5d25f7f067e5b9d9b6c5de82d6d989dd04c7be40b4aef0beddb1ed"
  license "MIT"
  head "https://github.com/projectdiscovery/proxify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91c0b93902207b7027a48b69ccf3de62f3cb8586c3d5b005c75cba874b20c598"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c0b93902207b7027a48b69ccf3de62f3cb8586c3d5b005c75cba874b20c598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91c0b93902207b7027a48b69ccf3de62f3cb8586c3d5b005c75cba874b20c598"
    sha256 cellar: :any_skip_relocation, ventura:        "630e0642c1a3f8fb0bb23c0ba5536ea794eb5aca7356a86529950f305f86c92e"
    sha256 cellar: :any_skip_relocation, monterey:       "630e0642c1a3f8fb0bb23c0ba5536ea794eb5aca7356a86529950f305f86c92e"
    sha256 cellar: :any_skip_relocation, big_sur:        "630e0642c1a3f8fb0bb23c0ba5536ea794eb5aca7356a86529950f305f86c92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32bdc9d7b5844b596eb441cf8795933b7320beb3130f1776f6d1583942a5ed88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/proxify"
  end

  test do
    # Other commands start proxify, which causes Homebrew CI to time out
    assert_match version.to_s, shell_output("#{bin}/proxify -version 2>&1")
    assert_match "given config file 'brew' does not exist", shell_output("#{bin}/proxify -config brew 2>&1", 1)
  end
end
