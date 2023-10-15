class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/22/25/e42c9be788883c94ed3a2bbaf37c2351cfe0d82cdb96676a629ed3adedec/nvchecker-2.12.tar.gz"
  sha256 "4200ddf733448c52309f110c6fa916727a7400f444855afa8ffe7ff1e5b0b6c8"
  license "MIT"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05ed5fdffe2be04d95332861c119b3b7d9e9833b94c2082a0f5de6335805e5e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d060f8e0b16cb3793c59030b94183ab90a00f1bc45349544a5e29103a531768e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b98554001621cccd4aa11017797e6df0be2a0329a571f468796e9d05047f5af2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a34cb5e2bc9c3cef323193f7539c6d47dcb8afce17aade04db0c2c215e9582c6"
    sha256 cellar: :any_skip_relocation, ventura:        "76ccf0a122b395be8bab2a0f270db9c54591d8653ff63a1cdf19d9d6c6739647"
    sha256 cellar: :any_skip_relocation, monterey:       "b42fe78a7822a22eedbee5763b8e228a09d9822a4672f4e7fdc4d5f08825856b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a272820b38e39cee19277bbb24c5339e294731ff8654c17601a7ee1f2920233"
  end

  depends_on "jq" => :test
  depends_on "python-packaging"
  depends_on "python-pycurl"
  depends_on "python@3.12"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/99/4c/67e8cc235bbeb0a87053739c4c9d0619e3f284730ebdb2b34349488d9e8a/structlog-23.2.0.tar.gz"
    sha256 "334666b94707f89dbc4c81a22a8ccd34449f0201d5b1ee097a030b577fa8c858"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
