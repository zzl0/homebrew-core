class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.39.tar.gz"
  sha256 "1cef76643592b2de2df72885f144d2295e322720e7c268366fc99ca7aae82061"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62976b65b4dd5d7bee31709ce9ba929206c0399695feec41bb6d69e1d9ac3edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62976b65b4dd5d7bee31709ce9ba929206c0399695feec41bb6d69e1d9ac3edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62976b65b4dd5d7bee31709ce9ba929206c0399695feec41bb6d69e1d9ac3edd"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc13b9b2b6743b3f128b6a9677fe8fe8a0513ca62c68d2a14fe8f78a82cc078a"
    sha256 cellar: :any_skip_relocation, ventura:        "fc13b9b2b6743b3f128b6a9677fe8fe8a0513ca62c68d2a14fe8f78a82cc078a"
    sha256 cellar: :any_skip_relocation, monterey:       "fc13b9b2b6743b3f128b6a9677fe8fe8a0513ca62c68d2a14fe8f78a82cc078a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "984819a93ef2eb532fc67d7f149ab1b82b9a468d7c0597eea5356ab8b81294d7"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
