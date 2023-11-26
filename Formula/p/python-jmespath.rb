class PythonJmespath < Formula
  desc "JMESPath is a query language for JSON"
  homepage "https://jmespath.org/"
  url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
  sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  license "MIT"

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

    bin.install_symlink "jp.py" => "jp"
  end

  def caveats
    <<~EOS
      To run `jp`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from jmespath import functions"
    end

    test_file = testpath/"test.json"
    test_file.write "{\"key\": \"value\"}"
    output = shell_output("#{bin}/jp -f #{test_file} key")
    assert_equal "\"value\"", output.chomp
  end
end
