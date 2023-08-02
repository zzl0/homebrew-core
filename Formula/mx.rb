class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/6.37.0.tar.gz"
  sha256 "7a5c710aff526953390ca514eab6b8bb8c1a5b705f08207965caf136e51d3968"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed599305dbcd16e16fafcdfc75e71d4c3a15fb7463de333a1f60924ce99585b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed599305dbcd16e16fafcdfc75e71d4c3a15fb7463de333a1f60924ce99585b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed599305dbcd16e16fafcdfc75e71d4c3a15fb7463de333a1f60924ce99585b3"
    sha256 cellar: :any_skip_relocation, ventura:        "ed599305dbcd16e16fafcdfc75e71d4c3a15fb7463de333a1f60924ce99585b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ed599305dbcd16e16fafcdfc75e71d4c3a15fb7463de333a1f60924ce99585b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed599305dbcd16e16fafcdfc75e71d4c3a15fb7463de333a1f60924ce99585b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01219806c41ad00e15c11ed0c03a1b1ab266c77e9c60c3e24c236727dbef0de"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.11"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.11"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  def post_install
    # Run a simple `mx` command to create required empty directories inside libexec
    Dir.mktmpdir do |tmpdir|
      system bin/"mx", "--user-home", tmpdir, "version"
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/oracle/graal/archive/refs/tags/vm-22.3.2.tar.gz"
      sha256 "77c7801038f0568b3c2ef65924546ae849bd3bf2175e2d248c35ba27fd9d4967"
    end

    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
