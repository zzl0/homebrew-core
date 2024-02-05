class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/d4/7a/67d2f81995098180752d328697bbceab959d8bac1c482400d0b901bf19b0/dxpy-0.369.0.tar.gz"
  sha256 "dc2f58723d70c6d02155c08d4ac65f41f63aeb05000e4782940d2196b05a962b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f111c08362a8a8c0593b8e618840d82ad48561eb18f724178488d3862d58969f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2385d7891f39896eebd79d653f39a04a48d2d64faffd7f8b07b12a592b4eace7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf926db1a562e59a2bb912ec522165ff4b6ce242bd1d1c1328e76cf39382223"
    sha256 cellar: :any_skip_relocation, sonoma:         "1100fa6ca00d4a0c91964f31ec62a065ff60f8bedb3ece8425a8825bc7a6d0ac"
    sha256 cellar: :any_skip_relocation, ventura:        "67ded1129c3f43676b26d81d5d2ace2fa3fdd2a83c7822d11702acad5b58c310"
    sha256 cellar: :any_skip_relocation, monterey:       "dba178b7819fe54ff075c348631df50401ef5806ecb2bc1104c47849b31b5221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a153e1dec2c437ebd569821703f9404bcf96487e41558ea80bb2651c8a1d84b6"
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

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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
