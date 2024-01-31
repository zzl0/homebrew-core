class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.183.tar.gz"
  sha256 "77945fec3e6c0b3714c77707ae854c701de88cc5fbb1b606edd4751e3750e161"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "192fda97b2b6738ed6c7a8b66b13657137a516d517fcc201dec2ef75327425fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b497dd73e504c5842a0ec7decb653fe360d5ce8abe1b0480a50d06ae4a582b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ff9249f04206a3274c1b69cf8679a4e843acc2df48b9a942203eb939c116dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aaab9dae0ac7f7fd77eb8b478faefaf2347d5d93d6547d16caef3d33ed2022a"
    sha256 cellar: :any_skip_relocation, ventura:        "3a64c82006f1284f4e9d64f78bd062e7a1d9871f1449831121ca24a30f19cf01"
    sha256 cellar: :any_skip_relocation, monterey:       "9cff7dcf65481bb91ba4bce21ac5162a3a9ac7c1f43e0a5b5397de969be90578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b4a6059c18e8b38e24e5919429539da7360f889d13994f115c66ef420c7aa6"
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
