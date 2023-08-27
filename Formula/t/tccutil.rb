class Tccutil < Formula
  include Language::Python::Shebang

  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.13.tar.gz"
  sha256 "b0e3f660857426372588b0f659056a059ccbd35a4c91538c75671d960cb91030"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "27033a9fedb26e4ea0087263ed08c2ab7136ca8258ac08f2fd0e6511d217c481"
  end

  depends_on :macos
  depends_on "python@3.11"

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  def python3
    which("python3.11")
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python3)

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), "."
      end
    end

    rewrite_shebang detected_python_shebang, "tccutil.py"
    bin.install "tccutil.py" => "tccutil"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_match "Unrecognized command check", shell_output("#{bin}/tccutil check 2>&1")
    assert_match "tccutil #{version}", shell_output("#{bin}/tccutil --version")
  end
end
