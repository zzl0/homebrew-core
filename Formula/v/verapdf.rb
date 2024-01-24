class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.176.tar.gz"
  sha256 "2dc2bc60c37483c7d4785962db299c8af35a8cf49d398e887bc2a23eb3684fc9"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd15029f0655bd1192af2e962f6bbaeda3b47212989d681ae10b6b871a95262c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a57cf7331cde1258161bec923080488ab7548871d067c268b62df681464a7a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfdbce09a243bfb1a1313344488ea95b27108b82f587c6d71263c59bb95c03c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab9ee9c4273f974f3dd86b2d07022bfd65ca4042220e312ec640dafd6741530"
    sha256 cellar: :any_skip_relocation, ventura:        "29fcab02502d797dc887bf2c4c58a6f779c835a5ada6b0388b45694182c3e4b7"
    sha256 cellar: :any_skip_relocation, monterey:       "10acc13a241cf2f3774223bf34b11985fd7c2b666bec1b4f7a30aead9d61b378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e87657f3d64b46d1562ca6f7d080a5030db8b4d12f25df730f3c6fdb2d0102c"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
