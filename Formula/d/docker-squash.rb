class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/3c/83/c0a3cee67e2af20c7c337fd7cd49b49c9a741e785e7a4c631404a03b7a00/docker-squash-1.2.0.tar.gz"
  sha256 "33120a217fa9804530d1cf8091aacc5abf9020c6bc51c5108ae80ff8625782df"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ac52014f3d83c378a31a3c58cf59b8387330d28c137cfe1ec830242ed45b97d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d4ad94d4f688c6529334d9c51ab2cd0f6fa5a08e2153e598ba501b6a018572a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1480d96020bc81c89d9c0debd7f657705e0e163c341b01f05c82fc18a222c971"
    sha256 cellar: :any_skip_relocation, sonoma:         "92bba4b3f7679da5006d08deef5a70a1c6de4195cdb0c5599bb1ca36f702bc14"
    sha256 cellar: :any_skip_relocation, ventura:        "2220c67e0d9f9eb3d3c231e6e63fd5e743a5c022c28683ae73498ec41206d4ea"
    sha256 cellar: :any_skip_relocation, monterey:       "50e6359f9e5f4d7d0437c23d9b3b889ce406643227e0f93e5049038699861c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "853f1a721b943c0a8b4ca3b34abcd40fa07f2bea56dd0b02c063e91fa3d78106"
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
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
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
