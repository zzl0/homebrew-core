class PythonJson5 < Formula
  desc "Python implementation of the JSON5 data format"
  homepage "https://github.com/dpranke/pyjson5"
  url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
  sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
  license "Apache-2.0"

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

  def caveats
    <<~EOS
      To run `pyjson5`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import json5"
    end

    (testpath/"test.json5").write <<~EOS
      {
          foo: 'bar',
          while: true,

          this: 'is a \
      multi-line string',

          // this is an inline comment
          here: 'is another', // inline comment

          /* this is a block comment
            that continues on another line */

          hex: 0xDEADbeef,
          half: .5,
          delta: +10,
          to: Infinity,   // and beyond!

          finally: 'a trailing comma',
          oh: [
              "we shouldn't forget",
              'arrays can have',
              'trailing commas too',
          ],
      }
    EOS

    output = shell_output("#{bin}/pyjson5 #{testpath}/test.json5")
    assert_equal <<~EOS, output
      {
          foo: "bar",
          "while": true,
          "this": "is a multi-line string",
          here: "is another",
          hex: 3735928559,
          half: 0.5,
          delta: 10,
          to: Infinity,
          "finally": "a trailing comma",
          oh: [
              "we shouldn't forget",
              "arrays can have",
              "trailing commas too",
          ],
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/pyjson5 --version")
  end
end
