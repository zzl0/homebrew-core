class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.1/nifi-1.23.1-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.23.1/nifi-1.23.1-bin.zip"
  sha256 "0baefb3aa8e555fe076d6cfbb95c95bbe66ab7a415064d353ef855237e222699"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "242a0790bfbed76afdaad95cff53f06eafba5aca5ac8551265e356d467fe6899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242a0790bfbed76afdaad95cff53f06eafba5aca5ac8551265e356d467fe6899"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "242a0790bfbed76afdaad95cff53f06eafba5aca5ac8551265e356d467fe6899"
    sha256 cellar: :any_skip_relocation, ventura:        "242a0790bfbed76afdaad95cff53f06eafba5aca5ac8551265e356d467fe6899"
    sha256 cellar: :any_skip_relocation, monterey:       "242a0790bfbed76afdaad95cff53f06eafba5aca5ac8551265e356d467fe6899"
    sha256 cellar: :any_skip_relocation, big_sur:        "242a0790bfbed76afdaad95cff53f06eafba5aca5ac8551265e356d467fe6899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3780cdf037f313325329d85142a98fcd3f6952596f13f588991c5c778aed2b88"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
