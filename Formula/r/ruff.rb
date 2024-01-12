class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "36a32001c821b844d19fc3d95d6d9265b9ef03b08c5e0950dfa94191454b5a93"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cee067e5be5cd4ede84480782b4c8e8421901b356f9eb59bfaac009586eafc83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eafa67ced9e93475d6c599bdfb50c5544ff39b7cf907a67363259e7e169ffa78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc70005811a3f2184c710498f945df4eab20f8a9f336ca0b9f6511184f68e945"
    sha256 cellar: :any_skip_relocation, sonoma:         "e94d22adcf936d34e8f6ce4d7b7f60f2bd37dd400e897c5c554346c0f72a6bfa"
    sha256 cellar: :any_skip_relocation, ventura:        "54667ce321e85c6fe30ebc30de4310a2fb5002372a31fe4a793e937470a67b35"
    sha256 cellar: :any_skip_relocation, monterey:       "a1637b8a2ce33856ce49ee9e131960bc598e22f18e2b4192c0a07308311e4dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adfb8a4d5a0387808820e2fd50452054cbd216c2c96b7770635346dbe95ebfde"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
