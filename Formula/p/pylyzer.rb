class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "0c497a2560cadf0290659242c0da3f710502ba5cc95cccc2f2f70e4a732d2991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdd16b25ec54b0470ca57ace08eb05993563a51d4094f579ad49a7fabab92d12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23df1c72aa020ee72ccaa493858ea6888849a79a9a33e9eda74bffe7b81aa365"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8f71b3c6a118bab5b6c5cde1746fe6c922083a1ba3b72409a54ad46cc767a86"
    sha256 cellar: :any_skip_relocation, ventura:        "41468172d3cff3f492ce109adc48836421e8530cb7fdca5016611fb9e4ef5174"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7791c2a00cc595de12201d27c09f926337b45ef0ab7cbf018aa39a24ed4ac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0932bf3b87166cb7df6fbedf200c90dbb9dc41293e40b06eafd3a364138dd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b4d947926fd1be675f8dff425636ebae5d6862ed8b1f8677afef0c5b2230a2"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
