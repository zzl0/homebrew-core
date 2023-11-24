class AivenClient < Formula
  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/b3/dc/869bcceb3e6f33ebd8e7518fb70e522af975e7f3d78eda23642f640c393c/aiven_client-4.0.0.tar.gz"
  sha256 "7c3e8faaa180da457cf67bf3be76fa610986302506f99b821b529956fd61cc50"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b305efc5db3035efad11cc911c90a1938b2c411403d6ab670c55af43189b5b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "718117c6146a956d59a381792ad472e8dac03a9e38cfcf3f85bf3b9dd6795519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c6ed0f635a3c8099ed1c98a853b7fdf2573f6ee68715074347d5cbee023f2e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e30101059457e6767cee65852c4dedf67fdb29b3f7f91e337e24ceb413fb43b"
    sha256 cellar: :any_skip_relocation, ventura:        "057bf8cbd25c47248e7b668e7ccc74576e1211cde3af3da54f9e4d1ef8698f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "ff290091fb814250cdbf21a1fedfb5e50936ce075f2630d54046addaf468e69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57dcba0965c44a2bb7687c686234ff1d91c10d2817e8d5e7fe747fcd4d438c2"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
