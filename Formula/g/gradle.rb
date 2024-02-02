class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.6-all.zip"
  sha256 "85719317abd2112f021d4f41f09ec370534ba288432065f4b477b6a3b652910d"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df09397c2e9edc535112895fff292a3ffe73acc6e55bf92b6d20022557e7ba6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df09397c2e9edc535112895fff292a3ffe73acc6e55bf92b6d20022557e7ba6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df09397c2e9edc535112895fff292a3ffe73acc6e55bf92b6d20022557e7ba6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "31483b8c1349cb7e4733a2061cd669bdb644d1bfad5ebd3bb0f28e7ac637e585"
    sha256 cellar: :any_skip_relocation, ventura:        "31483b8c1349cb7e4733a2061cd669bdb644d1bfad5ebd3bb0f28e7ac637e585"
    sha256 cellar: :any_skip_relocation, monterey:       "31483b8c1349cb7e4733a2061cd669bdb644d1bfad5ebd3bb0f28e7ac637e585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df09397c2e9edc535112895fff292a3ffe73acc6e55bf92b6d20022557e7ba6a"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
