class Helidon < Formula
  desc "Command-line tool for Helidon application development"
  homepage "https://helidon.io/"
  url "https://github.com/helidon-io/helidon-build-tools/archive/refs/tags/3.0.6.tar.gz"
  sha256 "749cf3fd162bb9449ab57584c0bdf8874114d678499071ea522c047637de0f90"
  license "Apache-2.0"

  depends_on "maven"
  depends_on "openjdk"

  def install
    system "mvn", "package", "-f", "cli/impl/pom.xml", "-DskipTests"
    system "unzip", "cli/impl/target/helidon-cli"
    libexec.install "helidon-#{version}/bin", "helidon-#{version}/helidon-cli.jar", "helidon-#{version}/libs"
    (bin/"helidon").write_env_script libexec/"bin/helidon", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"helidon", "init", "--batch"
    assert_predicate testpath/"quickstart-se", :directory?
  end
end
