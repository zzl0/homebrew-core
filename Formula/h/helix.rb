class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/23.10/helix-23.10-source.tar.xz"
  sha256 "4e7bcac200b1a15bc9f196bdfd161e4e448dc670359349ae14c18ccc512153e8"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4deaac0584ab704b1013ad8f36d1dea61d6fb8877ea685846b7342e164f543a1"
    sha256 cellar: :any,                 arm64_ventura:  "ef6c29f888ebb6c4a5e46cf8b93aaa91278b0bf3ee64819bdb7b14ba37bacf91"
    sha256 cellar: :any,                 arm64_monterey: "b998914e72f311382d28c9b869a6897713a1cccca2cd316b3543567fe27d769b"
    sha256 cellar: :any,                 sonoma:         "347beb27e09efe3de9740e842e992367e02f79f5337887a6174ace58fe36930f"
    sha256 cellar: :any,                 ventura:        "44fd0fabcc454b96620e8fdf8f1c2190233a70574af75352177afa13e4e6d2cd"
    sha256 cellar: :any,                 monterey:       "27abf7b2efd7db94b188e7c8457af83267a628f48f7e0dfde5ec626252fa8bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00bc0e5b1e97e3318d84b8a9ae4337943c5fbab39680bd9841c310b60573868"
  end

  depends_on "rust" => :build

  fails_with gcc: "5" # For C++17

  def install
    system "cargo", "install", "-vv", *std_cargo_args(root: libexec, path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    (bin/"hx").write_env_script(libexec/"bin/hx", HELIX_RUNTIME: libexec/"runtime")

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx -V")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
