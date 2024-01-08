class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.1.1/ktlint-1.1.1.zip"
  sha256 "28a6be447900e0af38957293b58919873110ecbbdec331b21daa377711214207"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3daffed1b107aab4045fb6cc7ad5380df96a31631af2beb80d38f3c296dcdaee"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin/ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint", Language::Java.java_home_env
  end

  test do
    (testpath/"Main.kt").write <<~EOS
      fun main( )
    EOS
    (testpath/"Out.kt").write <<~EOS
      fun main()
    EOS
    system bin/"ktlint", "-F", "Main.kt"
    assert_equal shell_output("cat Main.kt"), shell_output("cat Out.kt")
  end
end
