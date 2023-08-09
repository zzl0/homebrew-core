class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.283.tar.gz"
  sha256 "4c79a2e527937a01ff7c6c47ee203d8e894c50e37f7d899d40de2a073bb50243"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c82dfff74a5ebe989e4f516e40583d694a3e86200c2590c85909eb060bdea96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9c7488ac0a0a839c0d48241d8c7655ae3ae982988b381ef00104d3f65d2e1da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10bccdf5f23821459ab9c92e1d88be6452ab78a10045e89da4bb6ef825462e41"
    sha256 cellar: :any_skip_relocation, ventura:        "ceea57ed956dc83ef38c5f0a02572f59a22dc13a71b1710fd81db96c2cba3d35"
    sha256 cellar: :any_skip_relocation, monterey:       "b388be8e49a0d5329e110502db63c7b329b5d36954e0f8f9d07bd0c3bff514da"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ad9c6a33d849effe709f79fec22bbeb6a48a732a81d203c98d3077ff0f3203a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e3a4ad3a6eda141518fec86df49603b7312be984c795589d808000ec39b7c17"
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
