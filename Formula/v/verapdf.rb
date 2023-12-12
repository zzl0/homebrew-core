class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.139.tar.gz"
  sha256 "5fde811493c8eac77ea42d6314fcc12fd9b7b8e5695e9536649161f4e84605e4"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cacd6e2e512b3c99f66c3e67902e2d494c630ed4fc47ed8f4b8344001033aee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90efe0df54fd7754a6f355051c7f6430a1f06c76f282c825bb4ce814942d3ef7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69f359fcc79c955180a428e2f8eeac8198261dc6ccb6bbc91505a0bead5abda9"
    sha256 cellar: :any_skip_relocation, sonoma:         "29b783749a7556c720d71e0a00aff89421aa9e15c2eb433ae84dc77abcd6dce4"
    sha256 cellar: :any_skip_relocation, ventura:        "4997dfed9483e99e09d88d610f48b85a6ccaf219ce76213b8084092f1ff47f13"
    sha256 cellar: :any_skip_relocation, monterey:       "168177574d823ede0c7c5c22de8f031b84fc98bd964429cb2433b424d647cb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1669bb0e1b603189af538d55b7455b06765fe0101cfec65fdeb2b2041875427"
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
