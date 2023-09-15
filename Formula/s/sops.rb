class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.8.0.tar.gz"
  sha256 "14fa25f2d6177c5444934612398426a8de3caf59348eae8cc228291cf750288a"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af2e464cb7767ed8036dd8eb583b44c3b81d141c331826e52936d3bc50dc778f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "532b45e1dd85175018d60b297edc2c2f07b4501f04eb23c18f64ba71fce49f78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f27c015b2ef19765f5b05bdc46294aad6e6a9702bf60379646b2d482fa66cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9901d633289cbcad89857d975830a6e06f05287ab4f63cc23a6f3eb684d3a4a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b33f0911a7f7ce779ae88f284e6e5e37d4d04ccea103005568cd0330559503b0"
    sha256 cellar: :any_skip_relocation, ventura:        "bcb01ac11ac3e2716c57de5b6c224ec82b7d72e83427afb6b6513eff55e5743f"
    sha256 cellar: :any_skip_relocation, monterey:       "db10b3c2e7d8601404f5781710a594290db30e21bf7f0c9a2ed39548a8d062af"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6fc0f83d3b83a4c8b278f8344e0f17f3c96146ee61afdb2959ef36029141d57"
    sha256 cellar: :any_skip_relocation, catalina:       "8bbc4dcac66038e6fbaf4c4b21f513e06f7a229268ba9ebbfd636a442bca3d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204d35174833b00da78eb1dc6f0191761d91e23d638a6c4cc660cb7a64835322"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
