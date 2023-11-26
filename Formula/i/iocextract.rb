class Iocextract < Formula
  desc "Defanged indicator of compromise extractor"
  homepage "https://inquest.readthedocs.io/projects/iocextract/en/latest/"
  url "https://files.pythonhosted.org/packages/ad/4b/19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1/iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/InQuest/iocextract.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "371c23a41ee9ba9e191399b996825e0b2f5cf620f1a17aa4f07db0d65207027a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc80dd7eea28c9c7510a0ef1f4e022fa02ab097d61b7ad25f6e08f2e997a929"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22a6153a86b029e001a6b296ee4939a974d5320612121d04c27aa7153c99833b"
    sha256 cellar: :any_skip_relocation, sonoma:         "614de6646ed8054525e6c96b4444f2bb12faf05e7088dce6b58f3b774adff345"
    sha256 cellar: :any_skip_relocation, ventura:        "6009dacdc27e7c92577467b0aae10233c38d1a999bd634b8e2a4dd645a7638c5"
    sha256 cellar: :any_skip_relocation, monterey:       "e748ec74d33ce750650e44ca4c20e57546c8786892353cbea557bbd65dd555d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce9bb876075f1983b121a3ee3327b9f52494d8c7028e3d6ce7ed1443308f09e"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-regex"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 6/3/2017 and cdnverify[.]net since 2/1/18.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}/iocextract -i #{testpath}/test.txt")
  end
end
