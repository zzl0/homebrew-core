class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.23.tar.gz"
  sha256 "0978b1e169a022b356c5a4e048724732ba63ea82e0654310b6738bf08c6269ad"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4934fdbab325d6130a955f05d6019e55fe53b72ec44471bcee7b2dfec8ca97af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "809ce8d5629ab7ce1c743e537369c8e86592c1f3a85b40ba25f2a1106cbc8088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42624f16bdffca3f3020e87a8b5ebfcc619e2b523749db00219c03a9fba610cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f282f1ba3392fb9b1e5d802b46867365c9566cf356493e8a6477d27a04d44a48"
    sha256 cellar: :any_skip_relocation, ventura:        "ed681680168d4b163f7b1f74fa1b14e8414260ed37c0ee92b17a62698f5bad6d"
    sha256 cellar: :any_skip_relocation, monterey:       "7c677ffa2b4bfd6887874668d1df67b075d2ba03656e90a0a236e5aca76d2c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85da77e32d0edff8c606e17c24ea3bbb56ab828aeb6b5d4b249c352bbec3b6a7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    share.install "share/fish"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
