class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.3.0.tar.gz"
  sha256 "cd6919eb945992721bd164291ebee11dbb62f06004061c0cfc5fa73e98197224"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c8599159ccf7b1ddd5c3119486319095b9e2f1e08d32a6931ad433ef5c78e3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "259bb681daaf8725f27a58c6fad811a95a71ef412055b5d467456c3d495c156c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434990ed67367f68e97046dadc16dd271dbdf27fa5c463340fa0d28a37f14765"
    sha256 cellar: :any_skip_relocation, sonoma:         "60b3cc0b878d7a4d4638f0fb70520c79b30db81cd3b5b7f58b1dee240f3d9581"
    sha256 cellar: :any_skip_relocation, ventura:        "fe32c49c9170e43f5abc5c7d462cf6e0706fad8074111330da040603459f39de"
    sha256 cellar: :any_skip_relocation, monterey:       "91fac04b5f6971ca5fc8cfa8ce01237ceccd73cbfcf065830b27ac691481e53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99afeade9178396042f682d0f7c9c17e37b27c08f082d7876103126aaa5c0162"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~EOS
      let s = "world" in "Hello, " ++ s
    EOS

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
