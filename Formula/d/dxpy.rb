class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/5e/0c/09aadaebd7676909ea1aa43982b74536f2d27a852956ef6443b6bae4ab09/dxpy-0.366.0.tar.gz"
  sha256 "4f00cc2611d8def8ffc0a996a53e8019fcdc658f827ea9cf56999be7d334ed32"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c2affb85d71e96d8d111c9ce4d7ef4eb5831de5983c4884b10d01b7f59512d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23f5526520387cd1cf2fe4636340a8248716d9093cc7464cce9f16edc6f67c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61920a47c79946b59b8e820a8efa185d809d068c5b363e55cc8e20e2745a9d2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e21878d045bbf8bdc25542b9af90327c862c3fe6d296f3ce63af42e69413b9fd"
    sha256 cellar: :any_skip_relocation, ventura:        "4342cfdbaefa523854739956ca2954f11abacaafd128db8b4401e4c4241c9c1b"
    sha256 cellar: :any_skip_relocation, monterey:       "da281f655c14692a7e811c8ee63453cbee83dd905e67aeebb27a1585bd65fd05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6201b8f816ef442ccd77074960052d57f0740129cee50224060732e3fe114c42"
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
    url "https://files.pythonhosted.org/packages/d4/91/c89518dd4fe1f3a4e3f6ab7ff23cb00ef2e8c9adf99dacc618ad5e068e28/certifi-2023.11.17.tar.gz"
    sha256 "9b469f3a900bf28dc19b8cfbf8019bf47f7fdd1a65a1d4ffb98fc14166beb4d1"
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
