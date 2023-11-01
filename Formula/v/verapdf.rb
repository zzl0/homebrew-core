class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.97.tar.gz"
  sha256 "53a1211fbb0d96a7d04f86ecf49159676d9b19b547739325bae30e73fbf6ed49"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4312a48d694f9f0a7deef2a554a9d3fdf31ffe56d0ed687c8867acdad6a48f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5724429d9a6704a461c16d99a5615e74024f896a23fcc8fad764f80c31c6310f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26902580258c101f8213195ab07334b410fd43178c9b122a54d4e9a1b59fe21f"
    sha256 cellar: :any_skip_relocation, sonoma:         "62fd60ec96fa24aa77ce928fad0a0ea8ab801410cd0df00fc245adcfd82a68c9"
    sha256 cellar: :any_skip_relocation, ventura:        "9c078b11d93d93187a146cb0c13f1d65bc93e08c433c3579bff108e2bc33ede0"
    sha256 cellar: :any_skip_relocation, monterey:       "cbc3c32ae4e5851e76471bf6a8b48f943c0e0019a06ca20590d3182b417c9fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a3bc2a3c0c5079f6a5895550dfe11fdde0b355afeee94d66416b83f1052eb6"
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
