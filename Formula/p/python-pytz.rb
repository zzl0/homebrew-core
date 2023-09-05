class PythonPytz < Formula
  desc "Python library for cross platform timezone"
  homepage "https://pythonhosted.org/pytz/"
  url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
  sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7b6a8de0c197a3751ad4f0a98e70bc0ca5435f2e15a2c58a87e4affec7d0ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8676f2020af72089f43d9db117d1650853274325cb6842fcbae0095132a92bd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7740f010ffd242a8dc074a3a47297f10e824c8dfa7cdb396c0b13147c80c0a16"
    sha256 cellar: :any_skip_relocation, ventura:        "49aa7f6e8b982c4837632c5b42c9ebc3727e84e72345efe8ba8edc54ccd4a1b1"
    sha256 cellar: :any_skip_relocation, monterey:       "0a561f044d2c2eabde9fd425df6c87263e9ff2cee7599536bf0b56786761c74f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f8b4b82ad4019130c7697ca8e2d76c8c7e5978b97ef95f50eed31bb93a76472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6745520399dd938522a863fc0e05c7549d13a5b907a776bcaf0f7a764f77624"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import pytz; print(pytz.timezone('UTC'))"
    end
  end
end
