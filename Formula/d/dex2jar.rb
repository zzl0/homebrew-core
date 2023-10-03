class Dex2jar < Formula
  desc "Tools to work with Android .dex and Java .class files"
  homepage "https://github.com/pxb1988/dex2jar"
  url "https://github.com/pxb1988/dex2jar/releases/download/v2.4/dex-tools-v2.4.zip"
  sha256 "ee7c45eb3c1d2474a6145d8d447e651a736a22d9664b6d3d3be5a5a817dda23a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ff845a14eb6055275b1144eb77d19334d57b2074bc7347136e23da4a180396f"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["*.bat"]

    # Install files
    prefix.install_metafiles
    chmod 0755, Dir["*"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/*.sh") do |script|
      (bin/File.basename(script, ".sh")).write_env_script script, Language::Java.overridable_java_home_env
    end
  end

  test do
    system bin/"d2j-dex2jar", "--help"
  end
end
