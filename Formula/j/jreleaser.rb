class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.9.0/jreleaser-1.9.0.zip"
  sha256 "b4c1eff349d6ac494e40422b6be109c547bc9b353a5d40417b40848925429234"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23ef3364cef7eac844533c7403316a7d617667d897fe8f25a3ceed43d305d77f"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"jreleaser").write_env_script libexec/"bin/jreleaser", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      [INFO]  Writing file #{testpath}/jreleaser.toml
      [INFO]  JReleaser initialized at #{testpath}
    EOS
    assert_match expected, shell_output("#{bin}/jreleaser init -f toml")
    assert_match "description = \"Awesome App\"", (testpath/"jreleaser.toml").read

    assert_match "jreleaser #{version}", shell_output("#{bin}/jreleaser --version")
  end
end
