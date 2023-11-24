class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/97/10/5ae9b5c69d0482dda2927c67a4db26a3e9e064964577a81be9239a419b3f/s3cmd-2.3.0.tar.gz"
  sha256 "15330776e7ff993d8ae0ac213bf896f210719e9b91445f5f7626a8fa7e74e30b"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28d9b2c93fface3ee5b3b7f425428899843271ab21857c6c4b665e0b121ebf28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be603203f6a2934b9c237d27ce3ca6a7a13f672710b0ce1e05f575316898f294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17923a25af17f825f4f14d1b61ca89001edd7ac42ea2cd21dcfd4d8859ea07d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "96fab4bf6f11afd0a21f97d25613df0106a590cbe6fe98da242cfb68eebdb9e9"
    sha256 cellar: :any_skip_relocation, ventura:        "a6f71d22a30b0047668626f7a9f456a414eb5e134ba53bf71aa972e7ffa86ff9"
    sha256 cellar: :any_skip_relocation, monterey:       "9920ee31b5a0646888d9f06a941daa3c5c85a001536a296cd7acb4f647c8d750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9fb159b3ac96273a2932c457932f7ae5d584fea8f5b118460bfdb2428c20f7"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-dateutil"
  depends_on "python-magic"
  depends_on "python@3.12"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match ".s3cfg: None", shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 78)
    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end
