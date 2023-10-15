class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/80/d7/c4b258c9098b469c4a4e77b0a99b5f4fd21e359c2e486c977d231f52fc71/Pillow-10.1.0.tar.gz"
  sha256 "e6bf8de6c36ed96c86ea3b6e1d5273c53f46ef518a062464cd7ef5dd2cf92e38"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "86d9fb31c775bfc0b1091bbfa041c33a37d489501ab8d49f67f9eeec0a1b0366"
    sha256 cellar: :any, arm64_ventura:  "0b9287d7a1e4e62a9f5520a9fcf081541216ca799a451a3e0dd7948e4f85d859"
    sha256 cellar: :any, arm64_monterey: "6a21835e24e1e4796e7849de57408da0454c332c1c7a3e15acd577342416b3b2"
    sha256 cellar: :any, sonoma:         "55a689868bab696e8feddaa74272510cb43be0e9237fa7f5d82ec18c36e2e21e"
    sha256 cellar: :any, ventura:        "ccc920e1126ab4a5824637ad7f4189e1c2d7ded562f2bc0cfab3e07e218c23fc"
    sha256 cellar: :any, monterey:       "fa61faa41190d13425d6b8e221f1811dd4725938cc002510e9fa5381c61515ba"
    sha256               x86_64_linux:   "954a645196cdb123046d4ed2aaa32ab1f5786d7ecb8ff4653035b91063cbe6a3"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "jpeg-turbo"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "tcl-tk"
  depends_on "webp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args,
                     "-C", "debug=true", # Useful in case of build failures.
                     "-C", "tiff=enable",
                     "-C", "freetype=enable",
                     "-C", "lcms=enable",
                     "-C", "webp=enable",
                     "-C", "xcb=enable",
                     "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    EOS

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end
