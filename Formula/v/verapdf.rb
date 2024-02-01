class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.184.tar.gz"
  sha256 "ef70322664e9e02a3a2a5668dd5e174932dd17ea8fce9b94049366be9877d6d8"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acc033b95fb30352e279951efeb5b2d02cdaeff58351b141c25ec3d1e76829c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdaabf9569c27a67bb77b4f9557d4be53d91e44d588f16f5615caca9e1a89428"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d995f6a0c9802bfa5c365dac022b9b4e50d7726a8bd2d49a2392bc50a56d685"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0b248625afe20bf3b1f06b668755b91aedad40112758ee2c7c298abb9b1e65d"
    sha256 cellar: :any_skip_relocation, ventura:        "bd66478019160de3199e18bd232a60e30a9d7610b7ec6035b35e43b4651a3dfe"
    sha256 cellar: :any_skip_relocation, monterey:       "734312b7b14eea06e1c4797882bb3ac0c77c723ae47adaf7a13a458c5e080b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4dde317931d81160728d7250ddeafbfb1f53e095d24e19595501f8727d2a068"
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
