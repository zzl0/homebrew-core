class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/ba/5c/b6bc3583a01c11ccf205bfe3a10d46f20de0645e5cbd613881b320d00b80/coconut-3.0.4.tar.gz"
  sha256 "106f092f91e6cf509415cc627bf52ecda71a065158614cbfe73fa73dceeed98a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db52e0d6a5e2524009b7ce23bf62f453dc0dbbc2d1e833f7b91fdc1ec1c7ed87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d150da03dbbdc798128a5e49905990401805e793f74dbc44674f6d8b1250824"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3978aab75be877dc206a76c73f2254f587101cccf00c82e36b2c8b74d21aed2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "259eabc26d6adc8d1078c997ac22a326ec7c490c28c650894e4ddf16024c4d9e"
    sha256 cellar: :any_skip_relocation, ventura:        "1fe79f37a88688b5e04da41e2f9cb06dc281eccb85b7eac10cf1b551e0336a27"
    sha256 cellar: :any_skip_relocation, monterey:       "14238493fd40f764bb5a3bb1f87aac37b06cd439e78c727f62291edf1fca28c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e343e2c13525b1fe786db1f33d24098cc80145fb523d7ef7ed2de47b3c661abe"
  end

  depends_on "pygments"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/2d/b8/7333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833/anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/f1/2c/be67465b34206c24be7230746f589f0d4adbb60f96e889fc248fd51b9e3d/cPyparsing-2.4.7.2.3.2.tar.gz"
    sha256 "746c6a780f7e64dc717ac1cc28ffbab7841df0672cad851d26cf15faa11a4692"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
