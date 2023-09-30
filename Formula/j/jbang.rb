class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.111.0/jbang-0.111.0.zip"
  sha256 "651cd36b02a704745eaf1bb6c04dab1596fa13a178dae6c2db427bbbeb9e3d86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b260543f24f78e12cc1390b19f8e53d1f1e0aa5974a3c90cdb2ca01f80d13e8b"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
