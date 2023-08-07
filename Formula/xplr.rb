class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "27800f0e731aedc194872609263e8c20b2e94b2f2e9088da5d3f501c406e938d"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe612cc773c23626caab8555ddb7325e64813b12c12551ab5c1c4dd28c57deff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7059857dc18a7003f8486ad88b2c6227ef7b0b87e88df421fcc1b7d89dbdc8b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be66c0f827359caf0127badc88dc929443e53c1955382ec982d3e298580b58d5"
    sha256 cellar: :any_skip_relocation, ventura:        "da779a4a2da11f23dc67214e5c92c82804213b6dc15f8477c1096ee505fefc2b"
    sha256 cellar: :any_skip_relocation, monterey:       "be1419a626d4f66be122b09eb679f09d13d2cd5476e799f92827679ae0df0afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b8b878c2f4eb2f20c98ae3b38c333e8645a7957ded47ef3206d4f41bf1f6a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3c0bc346680c2429382a13f2e868da3aae71858657d227ab5033653795740f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  # Avoid vendoring `luajit`.
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end

    assert check_binary_linkage(bin/"xplr",
                                Formula["luajit"].opt_lib/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index 48bd3e1..69cdd17 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -73,7 +73,7 @@ features = ['serde']
 
 [dependencies.mlua]
 version = "0.8.9"
-features = ['luajit', 'vendored', 'serialize', 'send']
+features = ['luajit', 'serialize', 'send']
 
 [dependencies.tui-input]
 version = "0.8.0"
