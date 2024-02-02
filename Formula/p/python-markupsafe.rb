class PythonMarkupsafe < Formula
  desc "Implements a XML/HTML/XHTML Markup safe string for Python"
  homepage "https://palletsprojects.com/p/markupsafe/"
  url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
  sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "018006555e7cf54d4558429d38289057a781532d775a29389f4beaf432e5b78b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8991744c23844ffc82bc293a40305fd6e445dd4688335276b4c83046b01f4cf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "976d68784834aeb6c306e196375b826ebc8e2d60ae52efcc23457452a32c8a4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3128f3606ec56a840b78d870aabe0a1a04e72dce5ff04613709fefa87acc0d44"
    sha256 cellar: :any_skip_relocation, ventura:        "ccfe30cecfd8ab886dbe44c500cac4e025c5a15f53c4efdecd468f4d5b49e04d"
    sha256 cellar: :any_skip_relocation, monterey:       "0d9ae4fe4f6f2a5e520816ba69f6bb50a285847bb77ca3fa53306c099a944b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403432611359beffb113d37c7498a59fbea3fca50c4925c11d2fdc5870f9e934"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
      system python_exe, "-c", "from markupsafe import escape"
    end
  end
end
