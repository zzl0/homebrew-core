class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.49.tar.gz"
  sha256 "733e89754636507b030432b6d0e2a2ec4f3ca0c15e535360afc7feadce45ffa4"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d01eb9fb4c243ffd8580b203555c7f728d16480c57b39719f24d0b9b5ea2fbd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00747e290b3207270d0a73002b51936abd8bd51e5d5e24b50257e7e8f17400a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bffee73857508022e99ae9595182b04a2c51a49519770e8681ddb17950b29383"
    sha256 cellar: :any_skip_relocation, ventura:        "ab2ca23748b14859e68fa0b7aedc34a0bbf0282f5330206a3711aa3616a3a388"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d1605292baaa2d79ae952f452d9d3950cbf452d2bb08348d532c19f0d969c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba22420328dc5c4ddbcd7798bc5417d90859ef42b18ea7dea460ba58240091e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e6fc24e8e786f675b5a4b0cc69f0f1d7e1fd3b23493372834285203102bb86"
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
