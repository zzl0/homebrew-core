class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.0.4.tar.gz"
  sha256 "b0be56b7337f645181e124ec51faba84f6f349a2b5b0694fe6beaeb88083601f"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "a60558ca7cc9c049c63fef8800a4230e6bf19f1a8d3889054f9e4116a82818e0"
    sha256                               arm64_ventura:  "82d9d5db1594b4f95525e45ffb1eb00e4aa04f46687584e81ec3a236e42c7503"
    sha256                               arm64_monterey: "dbba37dea09438bee1877bf45ec04e544afef8a69dbde17c0f45e3e30b14d026"
    sha256                               sonoma:         "156155f484b307161da955c9bda3404f14143175b915925686196d498c059efd"
    sha256                               ventura:        "72f64d616cfbfe003d0a09fc66dccfa79db508b875a6b937c1941e323e2b0725"
    sha256                               monterey:       "b18a56dfcf4cd3454a6383921ae4ac927fd7beb41df70d2ccafae4cb7b0d7308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79bacc5aae547894c5a2c6ed853cbff8468185988441c341a8bfc8d20d8c612b"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
