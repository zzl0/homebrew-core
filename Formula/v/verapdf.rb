class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.154.tar.gz"
  sha256 "94dad428aa486093f61ce2bb4464b4e5a10b8c9baad6f336d315355cfa99eb3d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "610bb5e7daa0ffe6f389aa1e98ca9b58430019e81aa64f097b400ede4d884868"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5e86b8461639e56854637a45021bea313f8baad8b79c845095a45cd185d9014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a5ef1fc3cdaf9ecf39c4ab10c697d83abf2aa3f73a56b1a6ecee030fa1aa198"
    sha256 cellar: :any_skip_relocation, sonoma:         "90fd48bec6a9199a34f925b184214c82b0884bd3645606865746b422a0144fcd"
    sha256 cellar: :any_skip_relocation, ventura:        "950283d04a6ea3e3faaa25781cc5b65b6b0d97907975396d7719df3621e72c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "85ee6959776b49cc88d2c0708db6ccc3365df0fd0d5783b04d92b69d1d63b914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a4ddb71ad982fe1fb809a574d84cea45a85d709bb0874076785f10c4c340611"
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
