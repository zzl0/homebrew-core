class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.64.tar.gz"
  sha256 "f38c7d8e16953a168bd26429d43613a4a8b35931a1167293ca084fec8fcba159"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a731a2a4d268410e094433de44a3deacca9e384054d94a438ccc8222c1152fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "348b9fa4e077547ed9f587f8d2ef245c56ec402acf1771b46c856751577334a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0c1c560e99dc82e2ef0858bddffa4573b7510c462753e7850011b5b01f74e5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce2f3c9931b750beac76ab284e6f4de095e32813578ae9736272c206ff5c4af6"
    sha256 cellar: :any_skip_relocation, ventura:        "930cf54d63109b7c8514e863c5551aa39192e7b5b9af2d1cd4ac3e0a660454b4"
    sha256 cellar: :any_skip_relocation, monterey:       "276047065e6c336952d520053231a8176b4b22d7c61aebcb018288f2dfb675a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af2231b10ec0543544238d417d4db09d9456963fc025fb95f74e5a1531a2a3f"
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
