class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/6c/0b/3684b7e34c46045dda03b34be50392c689b23fa8788a0c0f7daf98db35d8/docker-squash-1.1.0.tar.gz"
  sha256 "819a87bf44c575c76d8d8f15544363a7a81ca2b176d424b67b39cd2cd9acc89e"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cb889ad1ecaaf80af66a20932b55938048b59d85826c2a4a5037ff1b39a1f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62f9702c0b00672534187216d9f87e966b9525680282ff9d18d2f94921c47ddb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1738205c1f74d5c1b8d705441cd67159f5a5d44fba131dc5f42e914a85d81a05"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb58adffdfb9187219a19b8bee75151b693c602d845b8c347bf407f45ca29569"
    sha256 cellar: :any_skip_relocation, ventura:        "4e86ff72450897b754e132b559c999a35943a6ec895bd38d894b744724ff249e"
    sha256 cellar: :any_skip_relocation, monterey:       "eb03abf57b4fb9a917165816fa97a3378c0848b445eeb8e4a2fbf1e65daa846e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da87b72818b3e22a73372cb433b28d617d61d5784308a7c1cfe0a7a71af68787"
  end

  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  # Replace distutils with packaging
  patch do
    url "https://github.com/goldmann/docker-squash/commit/4a7fc2c3a2175d868ff60eefdbab53240a7641d5.patch?full_index=1"
    sha256 "33314b9d900b74e904c9ce7f0a358b70bc985703db01e1b9ac525f271ef62d15"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "does-not-exist:1234"
    output = shell_output("#{bin}/docker-squash not_an_image 2>&1", 1)
    assert_match "Could not create Docker client", output
  end
end
