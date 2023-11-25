class Fred < Formula
  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/dd/2c/51a14730b2091563018e948bf4f5c3600298a966c50862cd9ef98bee836c/fred-py-api-1.1.1.tar.gz"
  sha256 "e2689366a92f194f8f85db15463153a2116f241459ffc07d0bb5bbd5fb00837e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a50e24059e5934931b624416a8629772d499ffc3ad87fd038dc250ed9ae85b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9c8ce83fdc21f6f7ae542d188e370f36c4a0830735722f992f038c11156e0bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8ed5e8c7178e4deaf8a9b75e5329e01330c2001fb0c521db8d4095ca69e8fb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ff09f3adcd41215e36e142743f417a1b52935033259bdf58ad59e47da6633af"
    sha256 cellar: :any_skip_relocation, ventura:        "61f9d966633b1e39cc0a6a9297a76c63a817b1df16895855695ad503dd13814c"
    sha256 cellar: :any_skip_relocation, monterey:       "faa44d84025d387c65798b6cd14fd7e0014afe3b4c0ec3d438919ac5a864ca22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcd60b0e6fca55d04551575b3497c4c3d0baa9c21c488d6db57308783f455143"
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
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end
