class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.23.1/liquibase-4.23.1.tar.gz"
  sha256 "b9667d97a0ba425547aa9fe66bafeccf4ef3b821e91ae732ec684d0eaf2fd7f5"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c608ddbe4c126a406f9e33229ca9b2f7a0e4faee39857fb44fdbf21f4e997fe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c608ddbe4c126a406f9e33229ca9b2f7a0e4faee39857fb44fdbf21f4e997fe3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c608ddbe4c126a406f9e33229ca9b2f7a0e4faee39857fb44fdbf21f4e997fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "fc39452fabf442bd69cb4498322779d2b08b898e2f6bd53e3fbebbbe8e93a722"
    sha256 cellar: :any_skip_relocation, monterey:       "fc39452fabf442bd69cb4498322779d2b08b898e2f6bd53e3fbebbbe8e93a722"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc39452fabf442bd69cb4498322779d2b08b898e2f6bd53e3fbebbbe8e93a722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c608ddbe4c126a406f9e33229ca9b2f7a0e4faee39857fb44fdbf21f4e997fe3"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
