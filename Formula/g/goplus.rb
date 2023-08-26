class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.6.tar.gz"
  sha256 "e96c62e254d5600851b1479e03f05f7b70a91516de28b26b686c4b7f6b4dcb87"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "c4491a45561870db752ed10549dfa08c55a3ef78540d2f107439489fcde3037f"
    sha256 arm64_monterey: "a52268db166500a28bebd36555c23c5a32be7ff6b82ec611cd6294d26e891d59"
    sha256 arm64_big_sur:  "607a569175685f27ec5e149858a6ce86fee88eee82afd52597e5d8657285effb"
    sha256 ventura:        "68a0d939a8dfcd789be76605cfce752acf3e1db968cb220780919c1f86ede9e6"
    sha256 monterey:       "2bbe592a614ec333abf7c41182ec92bd1db8d67d8b6fe5b00e68f203d60ea454"
    sha256 big_sur:        "63f6a2a3e914b1ad3c5ce71f12218514ae789a3641626f3c56b197dd7e72332b"
    sha256 x86_64_linux:   "1c7abff51afc33d15a6d9ea0e8bc37cb66edf7cd384c19173e44078e8a633fb1"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
