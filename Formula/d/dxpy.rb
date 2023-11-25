class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/7d/6a/24de43eace08ff1512c658591466115949ae1bd8fed22e841f6e12f405de/dxpy-0.365.0.tar.gz"
  sha256 "234efe289c71da5069cb7e42f569c9dbff922e270267365d8b36798fd541240c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55601443c4c903803a06cb9f658dc585c0ab163f84055d36c2b149fc4347ff84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b78a3dba5d6fe68281a3101f05295e61dbee69bec56825825e26fcb7810e7ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dff2ff7f4719a70dd72a8b9c0cdc8ce6dff5c9e0ad51e075f4f43eab159bfe68"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c835ef1784e1b6379ce8aed3803ef191f7304fdcd1a65f319253865ba4c6b7b"
    sha256 cellar: :any_skip_relocation, ventura:        "400fc3e592d8086d0989a44ff5e75fa6463c9dbc0d4240f708cfab657ae5a736"
    sha256 cellar: :any_skip_relocation, monterey:       "314010187c4ba17ac71868bb41e74987cb13e96d766216730b3b7cf4e62c4460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "535e5c63c4e231b8246298ef6965f47f5646e99dcb99306630d46addefa8bde9"
  end

  depends_on "cffi"
  depends_on "python-argcomplete"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-psutil"
  depends_on "python-requests"
  depends_on "python-setuptools"
  depends_on "python-websocket-client"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
