class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/98/a5/f3d49178d1e69224d8680b0a0a02d42d221b45e703587bb2339a0503f421/lit-17.0.5.tar.gz"
  sha256 "696199a629c73712a5bebda533729ea2c7e4c798bcfc38d9cd1375aa668ced98"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a1817fc9e846520ed7f778c2f0e6278cbfbbb8a397394fadf65b50585ae1140"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12299f4be34e81f4812c16d721201bc4912f756cbb343b54bdba934e6c681e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f9e95849e7dc58f17d544aaee729fc8d36acc162f15cad3b18a102abba751d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1306bbb98a01d26111062835efdf7859ef073ca70d98e863169ff026bba31965"
    sha256 cellar: :any_skip_relocation, ventura:        "d31d0bb8e743794dd85f4fed2e180e60d91a2611d3df0fd292245ed7f46ee861"
    sha256 cellar: :any_skip_relocation, monterey:       "c906af42960c050a0eaefd0cb803f475a6ff4c04c97b50799ca3bc83960f7996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0102016a07bc061350a501c8520b75d9c9dcafaddb4fd7704d44e3b11247d0f"
  end

  depends_on "python-setuptools" => :build
  depends_on "llvm" => :test
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

    # Install symlinks so that `import lit` works with multiple versions of Python
    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
                             .reject { |xy| xy == Language::Python.major_minor_version(python3) }
    site_packages = Language::Python.site_packages(python3).delete_prefix("lib/")
    python_versions.each do |xy|
      (lib/"python#{xy}/site-packages").install_symlink (lib/site_packages).children
    end
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    (testpath/"example.c").write <<~EOS
      // RUN: cc %s -o %t
      // RUN: %t | FileCheck %s
      // CHECK: hello world
      #include <stdio.h>

      int main() {
        printf("hello world");
        return 0;
      }
    EOS

    (testpath/"lit.site.cfg.py").write <<~EOS
      import lit.formats

      config.name = "Example"
      config.test_format = lit.formats.ShTest(True)

      config.suffixes = ['.c']
    EOS

    system bin/"lit", "-v", "."

    if OS.mac?
      ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages(python3)
    else
      python = deps.reject { |d| d.build? || d.test? }
                   .find { |d| d.name.match?(/^python@\d+(\.\d+)*$/) }
                   .to_formula
      ENV.prepend_path "PATH", python.opt_bin
    end
    system python3, "-c", "import lit"
  end
end
