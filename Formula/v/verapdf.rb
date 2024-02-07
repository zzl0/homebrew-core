class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.191.tar.gz"
  sha256 "f22fae8cb5dca87460c9ef813b1df93488001f2b17f37496505895222bb4c2a1"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c400334c5feb6e21a268763d5e4a5d06109c2623d4c9247369084e567e4ad5c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d27e030021ed2957909fe724a86804f402af479acb5591e64504590241f2b153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "843fad80c196c6c86492e7fbd445b2e0a9eae26a2634103ccceadb26a745dedf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fdcc6b663a7448b3dbf84653d5a09c69d4f21f193d4072c57745eadd9831a02"
    sha256 cellar: :any_skip_relocation, ventura:        "f7b2b04107ef32d85decd5ffeb3716a17a725353cdaeef22fdfa95132c7bfbb8"
    sha256 cellar: :any_skip_relocation, monterey:       "3c5b30cb2400e4a193595479eca10c1e4693252e8d4dcf5e81d9cdacb9cb84ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075c4f32839184ea70f465bb74627518b9b602b41645fa989e4c3bbd1ae1c367"
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
