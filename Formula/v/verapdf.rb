class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.79.tar.gz"
  sha256 "6f700b20d801aebb8d130ba5b8e6544bee2389524875fa40ff8d1f3063df02e5"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c20b5b46f386b56ae55afd833e5a168ffec21565ebf690e452acfb09a797272"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20388c8fdf06330ad9846ef878dcdf52dda233d98d0b8dbffc9dc9a6d5a6558c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924673f311c0eb6a368e515495ee84a99cd0d868ada680cf979422f9dc5b850a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9770981726f01c80983139cd3cf6696f07b4c5d0e9cb0ce1db3007a12836cb50"
    sha256 cellar: :any_skip_relocation, ventura:        "0279b6ef8bed7a9b1f8cefc6e13f3c3f1e7852d03e944ebc51db1d564d1369d2"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b2cbc264ca762209d2ff9ce7ac3d3cd8ae0f62f12e4089972fe8575c4c0477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64fe6025470b4603310b428f5f4a56f2108f06056654228225157841c0b65d26"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
