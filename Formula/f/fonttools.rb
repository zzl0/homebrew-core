class Fonttools < Formula
  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/dd/e5/9adc30ebca9009d5ad36c7e74462ee5fc51985ca9a845fd26f9f5c99b3df/fonttools-4.47.0.tar.gz"
  sha256 "ec13a10715eef0e031858c1c23bfaee6cba02b97558e4a7bfa089dba4a8c2ebf"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28fc8131385e0cdc4fee3bba313a04117f9932d21833f9ae8c318fbefb6e6c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e9bc799453b93ad63f583e8cd586233fe9291319608c83c93d0074b20d81dc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ad0bef08e6d570c5516274a6857b65e334fdf10488595d74955950f618ea4ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "65954c06fc9296e69219808c4ea9ba0b4728e7babaf3292b6c9906cb767c69f2"
    sha256 cellar: :any_skip_relocation, ventura:        "012c2cc87c44be70ad102025075b4292b0ec5e23fdf7a18c329b7bf54510c90e"
    sha256 cellar: :any_skip_relocation, monterey:       "59625a8fdc12337d76d7ab399049af96ab3272ee473c034fcee3fd27d2d41d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "475df0452213c020625a8572d033f940884c95c074b7e27fd4e1e0a4472588e0"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-brotli"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
