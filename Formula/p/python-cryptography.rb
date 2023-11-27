class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/4d/b4/828991d82d3f1b6f21a0f8cfa54337ed33fdb52135f694130060839cfc33/cryptography-41.0.6.tar.gz"
  sha256 "422e3e31d63743855e43e5a6fcc8b4acab860f560f9321b0ee6269cc7ed70cc3"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8bd6fdbd9a6b621bb7d11e37deb3996d3a17312fbc8300531f1034c4e8e9226"
    sha256 cellar: :any,                 arm64_ventura:  "fbdb75e65c0b57c54dc2ce692fc0a410a615938040bd2ffed87f2ff0f851f967"
    sha256 cellar: :any,                 arm64_monterey: "7c931110a5a8b0bc7ed00ab1002229778244e7aea677c5376c1b55169d71e2f2"
    sha256 cellar: :any,                 sonoma:         "79b3932bf40cbbbeefac349f3d0205fe48e0dc1e8c9b78d7b348eaae2b664f16"
    sha256 cellar: :any,                 ventura:        "e3bf4e689f36ec006cc4422299af3b71de28c1685788f52a54a74186b5cdb98c"
    sha256 cellar: :any,                 monterey:       "9c123182839bb8f114c67c17df0c26c2a1119708048dbf8db21c51e3672ae966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a59ca5d1daaf9a179b7b0207d46daab604fee39ba88d2209a19c05609be39d"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/f2/40/f1e9fedb88462248e94ea4383cda0065111582a4d5a32ca84acf60ab1107/setuptools-rust-1.8.1.tar.gz"
    sha256 "94b1dd5d5308b3138d5b933c3a2b55e6d6927d1a22632e509fcea9ddd0f7e486"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end
