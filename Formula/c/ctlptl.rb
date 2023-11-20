class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.24.tar.gz"
  sha256 "de5c597b5b05c414332d54b93472cc7a7dd207d58b1d02a6cbeace460a01c786"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6da1456e6947fd8ccd266340f0d3dc992df8f6892dcf6e497554dd68f36072d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "132ecf1e56abaf8c93199b9a252b6e9b596927251e45bf3b23262226aad1dfab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5033cc826158bc41978b9d409cd25de0a13b08d45d8a123f12dae171d981b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5da0c6d9fe487fa3a118cada9fe7b141b32eb7ed4823e53c220715c885f8dd1"
    sha256 cellar: :any_skip_relocation, ventura:        "9f600dda366546e50e2c412e0795c6ac612979df5d1f4490d39e1d3670bec9ef"
    sha256 cellar: :any_skip_relocation, monterey:       "03d19655f61c7a9037a7a45f607dc21bc41d884b938b1867918cad8e56ff2f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f25b66dfd8399ecbacc01ff8b000f927358fb29c898167bec4ea8e01df5c7ad5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
