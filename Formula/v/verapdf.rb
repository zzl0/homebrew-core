class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.153.tar.gz"
  sha256 "c48d6d21b62393da8dc7b1b1dce5a772adcdea2f50d4050fc849d026cae7fb10"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33664e9f0c71e88e54a181c47e30a663bea3a053bf9d29fc5c48d5935b9adf32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5b44399164301f4c799cfb4190b17784197a96d503607ac4175ad613f681dfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d65f79bd50dda279fca768bc7401ace7e1c0d8d96bb797299ca05dd95f425cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc1587b5fd279fb45dc99b691db7a6da1bbcf947f22642fa4cec6d65bb257e78"
    sha256 cellar: :any_skip_relocation, ventura:        "d44fa9572d47b1ec59fb60cc4ebd4f12bbeb9cd9bbd69acac66e51e37f926b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "3cf4fa447030d6fadd63ea734413ed63f284e7de26e5fc1dd242df92575de461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35419d4e415ceb36ce78eae18d459dfce8a1ac9a1c4efd30368a2924ff95fa22"
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
