class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.13.1.tar.gz"
  sha256 "e59a87ebd380d25e76701e163b9dd447b0c3ad94b5f7b68885d0cc94d8d956d3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd09119803e5c61d9c1f5505f47776513b193fbe8dbcd8b50fffb4fd86e50f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3c20d78e2732faca7de2dc2424ee36da0f5ceebbb2777ae8209ce78328ee69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "378ca39b4cafa214771a91cd80302cd823acff523ba16e3e549863832133f6cf"
    sha256 cellar: :any_skip_relocation, ventura:        "696dab813de8f6dbe44ccb585678b4cb25b99211cae1699a50a8f314cd5e6935"
    sha256 cellar: :any_skip_relocation, monterey:       "957ce92eb74f8b24d53e4d6f02746a2cc7732d1691c5ea9ba521ffeb1418d9be"
    sha256 cellar: :any_skip_relocation, big_sur:        "4be416b0bfe113cc2c3a7a29cf0873ff5727c779705f146b165f4ce668be3ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b428a3c752e308cd8b661dde30234581b85e4a0c544f43ccef82499773fdf53d"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
