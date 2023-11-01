class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/17/dc/969e2da415597b328e6a73dc233f9bb4f2b312889180e9bbe48470c957e7/PyQt6-6.6.0.tar.gz"
  sha256 "d41512d66044c2df9c5f515a56a922170d68a37b3406ffddc8b4adc57181b576"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "afe285e05cf069bbd31e575742d1c42cd031de72879bb8645d9df3ece7c426b6"
    sha256 cellar: :any,                 arm64_ventura:  "d6235340f5b8bed96fcf1fc329b8469420dbf603cb708f177dccf412686aecbb"
    sha256 cellar: :any,                 arm64_monterey: "fb4b5563e49b887444c8d0c9d9ad7456e79956664dc81092245025075a10cadc"
    sha256 cellar: :any,                 arm64_big_sur:  "5136004db0464984b6a2cc37b4668f8558743a6a9df6b93fd5397ff44c3774f1"
    sha256 cellar: :any,                 sonoma:         "a3aadeedee462ca037ec98e03c31223f28187c8fa3eb221234fbf2b3959be3ec"
    sha256 cellar: :any,                 ventura:        "399b7e53bcfd275b0ea3699197e57f47cc6e4a435070358316effccccc61533b"
    sha256 cellar: :any,                 monterey:       "d761013b21ed972fdda44e2fc010801a6776bc7e25800bdaba96c8b92f368953"
    sha256 cellar: :any,                 big_sur:        "47d34d958146dedb529f4ecca90f8b9a63dabafa16378ae6cd406bbe4503bb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce996c6a606402baeba727decc8ff59aec06c962424ba6c3d80741735cd14a5"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.12"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/3c/3f/7909d2886f500b9512a544c46c4e3e213a7624229a1dd1f417b885dedd6e/PyQt6_3D-6.6.0.tar.gz"
    sha256 "372b206eb8185f2b6ff048629d3296cb137c9e5901b113119ffa46a317726988"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/ef/7e/88d25f0c34a795744d8b87d0bdb5c76ce0e28f4070568e763442973c3e2c/PyQt6_Charts-6.6.0.tar.gz"
    sha256 "14cc6e5d19cae80129524a42fa6332d0d5dada4282a9423425e6b9ae1b6bc56d"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/e1/ca/8b4a4ba040ecfa4fa0859ee8dcb99095f19c4ca5e42255821c9a6feafde8/PyQt6_DataVisualization-6.6.0.tar.gz"
    sha256 "5ad62a0f9815eca3acdff1078cfc2c10f6542c1d5cfe53626c0015e854441479"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/c4/db/b4a4ec7c0566b247410a0371a91050592b76480ca7581ebeb2c537f4596b/PyQt6_NetworkAuth-6.6.0.tar.gz"
    sha256 "cdfc0bfaea16a9e09f075bdafefb996aa9fdec392052ba4fb3cbac233c1958fb"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/98/23/e54e02a44afc357ccab1b88575b90729664164358ceffde43e4f2e549daa/PyQt6_sip-13.6.0.tar.gz"
    sha256 "2486e1588071943d4f6657ba09096dc9fffd2322ad2c30041e78ea3f037b5778"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/49/9a/69db3a2ab1ba43f762144a66f0375540e195e107a1049d7263ab48ebc9cc/PyQt6_WebEngine-6.6.0.tar.gz"
    sha256 "d50b984c3f85e409e692b156132721522d4e8cf9b6c25e0cf927eea2dfb39487"
  end

  def python3
    "python3.12"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("pyqt6-sip").stage do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]\n"
        system "sip-install", "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system python3, "-c", "import PyQt#{version.major}"
    pyqt_modules = %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Multimedia
      Network
      NetworkAuth
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    # Don't test WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
