class Waybackpy < Formula
  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5bf1bce44dc1a46ab6c988f58915c63f8a8709962986987e91c8a255f8603c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a713a2956f37cab4f6c07bda7b18dc86e12936f79d5d91121456aef286add7f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfda64b6d9ac8b3725d9b18122460472973f190f2a27c2be7be453cd6cafb9cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b39e29681710a0065b3be726f177ca1840fd887665a5e441889e40479f083cb"
    sha256 cellar: :any_skip_relocation, ventura:        "85621b1ce752de50d387cd8cd69076593cae944eb297a67cfa3eed6b67987397"
    sha256 cellar: :any_skip_relocation, monterey:       "53d35b19c4e49843a6b0d1df1e94bd74a6a2b5f2668e187942a208076fac3146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c1aa73ff33f69470a1111d0b90d3d9af70fa55929619f623b0f90624243a74"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
