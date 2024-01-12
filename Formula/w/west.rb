class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https://github.com/zephyrproject-rtos/west"
  url "https://files.pythonhosted.org/packages/ee/7a/4c69c6a1054b319421d5acf028564bb1303ea9da42032a2000021d6495ee/west-1.2.0.tar.gz"
  sha256 "b41e51ac90393944f9c01f7be27000d4b329615b7ed074fb0ef693b464681297"
  license "Apache-2.0"
  revision 1
  head "https://github.com/zephyrproject-rtos/west.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bb870bcf5e5040b99e408305cf691efc0f386d46ca6d85d857ad25232583e53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b56dc1ae2605b70b85c80dee664bda576a0becc9d31ed54b5eaf1a8396541d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a86c4f1654c564b51d6980c8dfa071cd5a90564741722b01511a5522ee4b107"
    sha256 cellar: :any_skip_relocation, sonoma:         "b963549faf1b5450da940d8ca35cf62114b9fddc79023f92a745a00354012642"
    sha256 cellar: :any_skip_relocation, ventura:        "50aab5b051ae5a8ce493138b6cd09bf03f8a8cedf628d1426bba396e16030895"
    sha256 cellar: :any_skip_relocation, monterey:       "6003cede937db2cad7b51e8fbc31613771d66214091c14808880a280feb70c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c13b6ef898a83b0a4434bc8b396e4f0621cb8794b0e807f952d811bef7d8a3"
  end

  depends_on "python-dateutil"
  depends_on "python-docopt"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/fc/c9/b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7/setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/"west" do
      mkdir "test-project"
      (testpath/"west/test-project/west.yml").write <<~EOS
        manifest:
          self:
            path: test-project
      EOS
      system bin/"west", "init", "-l", testpath/"west/test-project"
      assert_predicate testpath/"west/.west", :exist?
    end
  end
end
