class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/95/bc/485c1ec8666496ce96ec17bb0158c299709b323b6c22e9ae6de18fdca2a9/organize_tool-3.1.0.tar.gz"
  sha256 "16012c34abdd39ee16ca0baa19dd97b5cb172951b697b806c6ec3d7a0d429c93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b43bfdf3871ac8b102f54980c6e6daea3381733ea036742bfb38ec785c728431"
    sha256 cellar: :any,                 arm64_ventura:  "4fe58d30fedf2abddbc5068018a5b1c77c3934f34d155d7d1cba04610c6a39f8"
    sha256 cellar: :any,                 arm64_monterey: "6ba82bbfd0d90c8168c04c8c7aa64bdb3628dc6e3c6df2875f41ee08d8c60ef2"
    sha256 cellar: :any,                 sonoma:         "26f4a0cddfe992098bd1d04c2d9fa5e793dedd205bcb3de8c2c0e8ab11336425"
    sha256 cellar: :any,                 ventura:        "31538839f8718c2de96d1a052a561dbf24740feee2e47a343d80f3a683d5cc14"
    sha256 cellar: :any,                 monterey:       "9a3e43ae37914ea61f6ab2d22187b86d216059c82b95104ce629c9be98927929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee45a33d2727ccf30cc217e9f3d193df00c5e6e256ab260857aa5fbb77d9850"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for pydantic_core
  depends_on "freetype"
  depends_on "openjpeg"
  depends_on "pygments"
  depends_on "python-click"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "exifread" do
    url "https://files.pythonhosted.org/packages/5f/a6/e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87a/ExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/78/6c/87e7c6e46206e27b3037acdf637906c4be500a0b1dd7ccbb805a72b9f494/pydantic-2.6.0.tar.gz"
    sha256 "ae887bd94eb404b09d86e4d12f93893bdca79d766e738528c6fa1c849f3c6bcf"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/a0/a7/61d013c73773bb03d02de9de8e4e5b2ed2c100dc98ae7046d54485ecf5d4/pydantic_core-2.16.1.tar.gz"
    sha256 "daff04257b49ab7f4b3f73f98283d3dbb1a65bf3500d55c7beac3c66c310fe34"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/4a/d2/d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551/Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "simplematch" do
    url "https://files.pythonhosted.org/packages/d4/c5/209aa49f6c366f5b1d80e9eef2f75270079df3c9dec4658e0716e4bcd6ab/simplematch-1.4.tar.gz"
    sha256 "55a77278b3d0686cb38e3ffe5a326a5f59c2995f1ba1fa1a4f68872c17caf4cb"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/9b/47/2a9e51ae8cf48cea0089ff6d9d13fff60701f8c9bf72adaee0c4e5dc88f9/types-python-dateutil-2.8.19.20240106.tar.gz"
    sha256 "1f8db221c3b98e6ca02ea83a58371b22c374f42ae5bbdf186db9c9a76581459f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    dependencies = resources.to_set(&:name)
    if OS.linux?
      # `macos-tags` and its dependencies are only needed on macOS
      # TODO: Currently requires manual check to confirm PyPI dependency tree
      dependencies -= %w[macos-tags mdfind-wrapper xattr cffi pycparser]
      # Same for `pyobjc-framework-cocoa` and its dependencies
      dependencies -= %w[pyobjc-framework-cocoa pyobjc-core]
    end
    dependencies.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end

  test do
    config_file = testpath/"config.yaml"
    config_file.write <<~EOS
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath/"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}/organize sim #{config_file}")
    system bin/"organize", "run", config_file
    refute_predicate testpath/"homebrew.txt", :exist?
  end
end
