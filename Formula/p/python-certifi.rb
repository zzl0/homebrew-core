class PythonCertifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/d4/91/c89518dd4fe1f3a4e3f6ab7ff23cb00ef2e8c9adf99dacc618ad5e068e28/certifi-2023.11.17.tar.gz"
  sha256 "9b469f3a900bf28dc19b8cfbf8019bf47f7fdd1a65a1d4ffb98fc14166beb4d1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7e3ade85f22742f34abc5d2d9fcbdb4b4bd7f48dc8a159632c031d8007189f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d97a923fa6705e96f28e4f4eee95dc546da9c3284f1dd72b1c8e38a3a0233a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4cca94c242a1491a3f719c601f4a27243b88a79afd66c7642f8807bda98643e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b24e2973e53c9b1d45cba54e396e204f0f704175f59aa5a64eb9b91871662de"
    sha256 cellar: :any_skip_relocation, ventura:        "093282849560012f202cf6b5059091f0ae0825a3e76dcfbb5bb83f3bce40023e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e4934e6512167a14e9f2fdac2a969e4ea36a72d959c794a7002c0a90cf7f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a540eaf727baaa449fe5ae998e22f704accdb80555824fb7171af9e12104256f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      # Use brewed ca-certificates PEM file instead of the bundled copy
      site_packages = Language::Python.site_packages("python#{python.version.major_minor}")
      rm prefix/site_packages/"certifi/cacert.pem"
      (prefix/site_packages/"certifi").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem" => "cacert.pem"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      output = shell_output("#{python_exe} -m certifi").chomp
      assert_equal Formula["ca-certificates"].pkgetc/"cert.pem", Pathname(output).realpath
    end
  end
end
