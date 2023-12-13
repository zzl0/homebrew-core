class PythonHatchling < Formula
  desc "Modern, extensible Python build backend"
  homepage "https://github.com/pypa/hatch/tree/master/backend"
  url "https://files.pythonhosted.org/packages/0d/ee/2afbbb1e8e17a792e83e894e35e4a151dff121aa841ebdbe92f4b51779fe/hatchling-1.20.0.tar.gz"
  sha256 "0e0893cbe3d5f9275fc0e5b629087fc23b17abd7065e4db0a310e0a0237bc945"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40585512588943a1d1b2f172853591258d9e04cc56548984d9bbf840a0e5a602"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385d0f6148e4c68c2f4f8d73db4f02bbc5f2b27f4c1dd63f7458cbccf1783fac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0226db0190cf76954950f7cc77bc1450ef13e9392fa15522f0325d5edb923e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "98bcb3bd4d38a864a8f0379231f93207eb66635410a88b52ea0d49d5846c1fd2"
    sha256 cellar: :any_skip_relocation, ventura:        "d85d12902558e8376011b300c07aa46c5c2546e0134e2cdc8c87f1289180b34e"
    sha256 cellar: :any_skip_relocation, monterey:       "0dbda1cf944f4a446882f5cbe6881739c2ebfb20b592fae11ab0220535c89cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622d5f5c2ca82cbb86fd94a962ab12e85048b63fd4fd59ffb2562c6b0f3920da"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-pathspec"
  depends_on "python-pluggy"
  depends_on "python-trove-classifiers"

  resource "editables" do
    url "https://files.pythonhosted.org/packages/37/4a/986d35164e2033ddfb44515168a281a7986e260d344cf369c3f52d4c3275/editables-0.5.tar.gz"
    sha256 "309627d9b5c4adc0e668d8c6fa7bac1ba7c8c5d415c2d27f60f081f8e80d1de2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/3d/14/fe9a127564317f1670d1dd2e2e74b9e09fc157563aa2ffbe7d113d004c7a/trove-classifiers-2023.11.29.tar.gz"
    sha256 "ff8f7fd82c7932113b46e7ef6742c70091cc63640c8c65db00d91f2e940b9514"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"

      resource("editables").stage do
        system python_exe, "-m", "pip", "install", *std_pip_args, "."
      end

      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install bin/"hatchling" => "hatchling-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "hatchling-#{pyversion}" => "hatchling"
    end
  end

  def caveats
    <<~EOS
      To run `hatchling`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatchling"
    end
  end
end
