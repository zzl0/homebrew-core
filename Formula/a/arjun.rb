class Arjun < Formula
  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/83/2d/e521035e38c81c9d7f4aa02a287dddeb163ad51ebca28bef7563fc503c07/arjun-2.2.2.tar.gz"
  sha256 "3b2235144e91466b14474ab0cad1bcff6fb1313edb943a690c64ed0ff995cc46"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "192f7ae94916acd47d28413c5abeb492a1642c1b059c1093c1e95cd62e87a073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47cd188c43e6f7b0e2b301c00d68da0ee61719941e239e75a176853800701322"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f112f1ad2d0a9d64ce41d87d1e664c3d601de97cde3de6146e13ef8202adae6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bee8fadcac1d7c77cce0e80c8cd0a9fc11f74180a1fd7522c789c0e14020d55c"
    sha256 cellar: :any_skip_relocation, ventura:        "a194a2368caa2bbf92f53635712e27c427b853f3f7242e8f7f0f1231b53c5d55"
    sha256 cellar: :any_skip_relocation, monterey:       "d925de5da66003db36f3e7b2414cea411c34bc28189cab5ccb4f87db076a295c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb9e5a170f2cda7983d63b6f598c7dd2106f81091360dd905aa7a064ea3b97b7"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-dicttoxml"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
