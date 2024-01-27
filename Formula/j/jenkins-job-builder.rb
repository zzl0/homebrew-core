class JenkinsJobBuilder < Formula
  include Language::Python::Virtualenv

  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/63/74/74dfd0a27ce1744a6971a70566ba6f15fe983047e8f6bdab1035703fa82f/jenkins-job-builder-6.0.0.tar.gz"
  sha256 "aae78fe91069c37d8f5dba73e92b4813a3dbed136c9b63b8b4d6abac3c1bd9c5"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e363e8ffba9fea51b3771dd251fb0b9c4aa26dcced533df25af64e2bb24d7ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "430964632a4f1619d660a1d41e28457f864ded999627dc31b94f946afcfbcbb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "221203f74961e006858f570f1224bd0c9d3228fb4b974d3380a56094013d1ee3"
    sha256 cellar: :any_skip_relocation, sonoma:         "67bd30b76036598c50dfd89d09b20ad85e55032f36934330b46d5571b3f68273"
    sha256 cellar: :any_skip_relocation, ventura:        "c28b8e05248307e24dc52efb33f36ef39ce1fde693c2b2faf42f42046659bb61"
    sha256 cellar: :any_skip_relocation, monterey:       "1e1833bb5532a4ecc918c0067ba53080c0e60674f227a50cad75145eeca8eeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4119aa8d7cb347d729b73998884826cfb46581865e93011eca7fc847b6cfe4"
  end

  depends_on "python-certifi"
  depends_on "python-markupsafe"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/5f/d4/e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902/fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "multi-key-dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/45/ac/2bc1d844609302f7f907594961ffba7d6edd5848705f958683a9c2d87901/python-jenkins-1.8.2.tar.gz"
    sha256 "56e7dabb0607bdb8e1d6fc6d2d4301abedbed9165da2b206facbd3071cb6eecb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    command = "#{bin}/jenkins-jobs test /dev/stdin 2>&1"
    if OS.mac?
      output = pipe_output(command, "- job: { name: test-job }", 0)
      assert_match "Managed by Jenkins Job Builder", output
    else
      output = pipe_output(command, "- job: { name: test-job }", 1)
      assert_match "WARNING:jenkins_jobs.config:Config file", output
    end

    output = shell_output("#{bin}/jenkins-jobs --version")
    assert_match "Jenkins Job Builder version: #{version}", output
  end
end
