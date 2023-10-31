class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/61/54/90cc12be502209315c17f35fbe5f05f2497d8e6677d310b9c503ecf703d0/pipenv-2023.10.24.tar.gz"
  sha256 "a28a93ef66e5ce204cc33cab6df30cca80ceda1f0074f25cc251ee46da85ab39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ce8b04aa530500024a82e62c428c3f209f09350b35a43eab882ac4976665f0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5503b7cb3e6af4975422e1f3648517b98eac9461eb2be271ac3e3dedb560fc3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096d0aec9c6bfe2aa66a3220ce45b6a0e28f1795fad0a9765b06133cd4a8e55b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef7fa1677f5835a7fed426610509453c6df592dc38758c62850ca4f5904113d8"
    sha256 cellar: :any_skip_relocation, ventura:        "bf0f9cb281b8d20a04a3303c16db3e77c2fe530b6915c9c261290c44e00fbbd7"
    sha256 cellar: :any_skip_relocation, monterey:       "26a897da4f9c7caddf6df469d02fc035c8d6f7d1ebc98e89ab73dbaca6f27357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e442c847a874afbf10d3a5bf8569ae42fb1ace18a734f9ee5c815a81f55e4868"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "virtualenv"

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
