class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.81.tar.gz"
  sha256 "2ced489baa63ea77480402d8ebfa9bd621ce0bc972abbc97f09528a2f39e438b"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26b72c47b9795c385b3d1afd90b0dafdb7590b78c9af4c8a5239bd76e161ef19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb850a6c5e2f4b7d13c2d9149a7496f20acc495446c82875e6f8bea3e45fd49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccd8db652170ec57a35095747a94c1d5b262f6674e4cea8940a7e13500e9ea7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a2dcc748a753c5e2e27ef82963add00f9c8b1d5deaefae39c64c761db44043e"
    sha256 cellar: :any_skip_relocation, ventura:        "a0c4d70adb5bfc33a739d76d3a2b93b9acbb6867b8383f8a7ec6758c51cb217c"
    sha256 cellar: :any_skip_relocation, monterey:       "90dc4c5940cdc39f340f834a5ab3b82704d0d38f0ba37ed0063b5e7baf8280d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3a076bc3076e252755fbd5ac91abb9b4e44758c9bd281f9c5cf4a457e47451a"
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
