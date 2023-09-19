class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ef/33/87512644b788b00a250203382e40ee7040ae6fa6b4c4a31dcfeeaa26043b/cryptography-41.0.4.tar.gz"
  sha256 "7febc3094125fc126a7f6fb1f420d0da639f3f32cb15c8ff0dc3997c4549f51a"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e39b99ca706e9ac7915874013724bb9c71314b5aa3b1ab89d7f75e66299f2f2f"
    sha256 cellar: :any,                 arm64_ventura:  "d7ead1f1511d83029e3f8ec317507c42a0080fb5190750924c66211037a6ec3d"
    sha256 cellar: :any,                 arm64_monterey: "ae1e8b4040aa85c1341930e624a62bb5daff8692d46106cfb7afbf9acfc708ba"
    sha256 cellar: :any,                 arm64_big_sur:  "98021dd3b22f142e4d3f7c74b2c3da9c2b04b6816d5fc45237e0e10dc5b64823"
    sha256 cellar: :any,                 sonoma:         "79767f8d968f19bdbaf0fda22f0039f9294e64a17a277b21951591f08cda057f"
    sha256 cellar: :any,                 ventura:        "c147b66c763acadc383ae2dbebe6e6cee0e5fd88e81c4ff3a5127816c9668b1e"
    sha256 cellar: :any,                 monterey:       "e3e7bd1c770b7ef3133a9bc285935e13a9a2ef9c51d0fe6751c63a9d74b710dc"
    sha256 cellar: :any,                 big_sur:        "6990d076d8becb612a83a790052fdc03c399ea3b85083b06ac74d1f750777679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b5a1fd8736d081f4e44f476fe93356710f845f2da60dbac4dc47de8baf7545"
  end

  depends_on "pkg-config" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "python@3.11"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/90/f1/70b31cacce03bf21fa645d359d6303fb5590c1a02c41c7e2df1c480826b4/setuptools-rust-1.7.0.tar.gz"
    sha256 "c7100999948235a38ae7e555fe199aa66c253dc384b125f5d85473bf81eae3a3"
  end

  def python3
    "python3.11"
  end

  def install
    site_packages = buildpath/Language::Python.site_packages(python3)
    ENV.append_path "PYTHONPATH", site_packages

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
      end
    end

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    assert_match "b'homebrew'", shell_output("#{python3} test.py")
  end
end
