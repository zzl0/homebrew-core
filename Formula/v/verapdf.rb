class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.151.tar.gz"
  sha256 "f9bad932901d10336a7dfb272929c2499bf1557b1b8fa8de8abc00d181ca287c"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "184402410882c36de4854f247af2c830f989bfe584506f55281dc4ded29278de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96fd9abf634ee2c4b7d6b31eaaad11fc8faab58d88d5005d832ade01841190f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b50311367a5fe89bd1e5ca3fb660cbe8d1e70edd91d37245dcb6dddcfec9deb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6863bc49b40514a08683f5ee8f0596f17225432bce8d7816d340c0f05494ff64"
    sha256 cellar: :any_skip_relocation, ventura:        "e1fe82ab1189bb49d769f42a219097ce1c3e22e1ece61f9ce32f86d35fc4a5e8"
    sha256 cellar: :any_skip_relocation, monterey:       "62634f52bef8ce1415148b2d094aa81d955e1580971c65d479fc20dc29993d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef2ddc8de053b898a78bb530a6f25d97182389a4e784465f627b38ad903e635d"
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
