class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "98680e52591428dc194a021e673a79bdc7799f394c1217b3fc22c89465159a84"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "455521db05c5d8927aec15c3912052b79f400e1b02268fdf9a33ddc57959eca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "455521db05c5d8927aec15c3912052b79f400e1b02268fdf9a33ddc57959eca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "455521db05c5d8927aec15c3912052b79f400e1b02268fdf9a33ddc57959eca6"
    sha256 cellar: :any_skip_relocation, sonoma:         "438a46c92e807446424c208b47cfe8762ff305ac5e3d86d45c44fa55f1434784"
    sha256 cellar: :any_skip_relocation, ventura:        "438a46c92e807446424c208b47cfe8762ff305ac5e3d86d45c44fa55f1434784"
    sha256 cellar: :any_skip_relocation, monterey:       "438a46c92e807446424c208b47cfe8762ff305ac5e3d86d45c44fa55f1434784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8829358672b5fd93fe53219fdb1bd774dec4a8010e325f342c2c9461d3a8b00"
  end

  uses_from_macos "python"

  def install
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"] # Remove Windows files.
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    system bin/"spack", "compiler", "find"
    expected = OS.mac? ? "clang" : "gcc"
    assert_match expected, shell_output("#{bin}/spack compiler list")
  end
end
