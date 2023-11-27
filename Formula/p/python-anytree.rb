class PythonAnytree < Formula
  desc "Powerful and Lightweight Python Tree Data Structure with various plugins"
  homepage "https://anytree.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
  sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  license "Apache-2.0"

  depends_on "poetry" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six" # upstream isse to drop six, https://github.com/c0fec0de/anytree/issues/249

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    site_packages = Language::Python.site_packages("python3.12")
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from anytree.iterators import PreOrderIter"
    end
  end
end
