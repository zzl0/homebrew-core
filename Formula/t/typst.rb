class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "741256f4f45c8979c9279fa5064a539bc31d6c65b7fb41823d5fa9bac4821c01"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0810332b6602e2e90ea27e4934f93177bb74bbf7798bfcec18ce3643b43d9a2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eea02cbdcdd8abc6822420375a610975db1b7719f48e29874905d08f5e376d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd21d78c8fea6c190e8d54a2b5cb9cfcb45a69040a83dfcc7d438d8d62397a5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e444a067bdc71f69320fe2271517d10d1d2a5b7bfbb7f6dbb5cc05b742e145b1"
    sha256 cellar: :any_skip_relocation, ventura:        "34efbdfdcaa8e5a391affe54e82429ccec7de4bc394947a752d87584b2546f52"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d00132fa3746e3face2142a783415530704652e09680a3d5a12d78e5c00233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620b130636039c817c77e543e3640a735e59f51ccfd7708fb91b4a55acef0050"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    ENV["GEN_ARTIFACTS"] = "artifacts"
    system "cargo", "install", *std_cargo_args(path: "crates/typst-cli")
    bash_completion.install "crates/typst-cli/artifacts/typst.bash" => "typst"
    fish_completion.install "crates/typst-cli/artifacts/typst.fish"
    zsh_completion.install "crates/typst-cli/artifacts/_typst"
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
