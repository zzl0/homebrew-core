class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "ff7dc24e0bb01120270e7fa455ec6a06b64a3918abeaa7019bcad53d9d3fba3e"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cc1b14d8d5a183722ceb05c9c9f3e6bb85314f0812fb51bce6561a754064d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48818a640c1d6a5eb75494f3d3b2da4d91c4ee0c7e369788b50d505d81d45f4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "366aff246d068544cdda52cb2fdad24db5a0ab572d74ee13b87f7a3736c95570"
    sha256 cellar: :any_skip_relocation, sonoma:         "e46a3a6c66ebd719520cbe62b392eec38c3abcafa5e58addccda1ec3433a0ff0"
    sha256 cellar: :any_skip_relocation, ventura:        "580f5abfe5f12f7577b7db39aa35f753b666dd49934de405e290bdf1adecee26"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6045a3fb49ce55dd10a8aae8752fd7fa3129f12cced9ac6f85077587736db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf4b0fa726e3e6dbdc511736824d89df8950677613ecff567a762273e1b70009"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scarb")
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
  end
end
