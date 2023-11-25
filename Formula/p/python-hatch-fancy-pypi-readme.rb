class PythonHatchFancyPypiReadme < Formula
  desc "Fancy PyPI READMEs with Hatch"
  homepage "https://github.com/hynek/hatch-fancy-pypi-readme"
  url "https://files.pythonhosted.org/packages/85/a6/58d585eba4321bf2e7a4d1ed2af141c99d88c1afa4b751926be160f09325/hatch_fancy_pypi_readme-23.1.0.tar.gz"
  sha256 "b1df44063094af1e8248ceacd47a92c9cf313d6b9823bf66af8a927c3960287d"
  license "MIT"

  depends_on "python-hatchling" => [:build, :test]
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

  def caveats
    <<~EOS
      To run `hatch-fancy-pypi-readme`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["hatchling", "hatch-fancy-pypi-readme"]
      build-backend = "hatchling.build"

      [project]
      dynamic = ["readme"]

      [tool.hatch.metadata.hooks.fancy-pypi-readme]
      content-type = "text/markdown"

      [[tool.hatch.metadata.hooks.fancy-pypi-readme.fragments]]
      text = "Fragment #1"

      [[tool.hatch.metadata.hooks.fancy-pypi-readme.fragments]]
      text = "Fragment #2"
    END

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatch_fancy_pypi_readme"

      output = shell_output("#{bin}/hatch-fancy-pypi-readme --hatch-toml pyproject.toml")
      assert_match "Fragment #1Fragment #2", output
    end
  end
end
