class JenkinsJobBuilder < Formula
  include Language::Python::Virtualenv

  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/74/e8/f559afa16434bd1280be101b24d2ea43cfbf5b4ad5a26cd4a5be86a60628/jenkins-job-builder-5.0.4.tar.gz"
  sha256 "fb3aec7f28b823cbde9c518c2970cc52afbdf9fef2e88639f72d7f3890c4c46b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c80e448109adab02c1323a62027ecd93979408f50bc6a298d19ad0c0b97b4d41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7fc0e4d8fc8fe933838d829eee69c0cf1a45028f47c47d90e74d2e05279ec41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e197891d69f28fb0e57fb0aff99f0f9e03682c16346e5fb0ebba957602ecb928"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51c98a529f1e8bc394679dd800839d05f0da6d061b4ad484ecd9b66fe5e1d95f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e53f6b10771c51bcbc7b2ad933d75d0e222b93cb84329aefa1220c7445440b7"
    sha256 cellar: :any_skip_relocation, ventura:        "6702bb17c8e192ca66cf9cc7c8d677c678d5d3f02c92cf9c0551a1aa0e02b148"
    sha256 cellar: :any_skip_relocation, monterey:       "028f3090cab6518f5bc722c2aab853e92d9182c1c9c0d432388d3b2a9a52cef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4816d383ae27b6298c4e74dd270f05934bd52e528e1a08946bc76d0ceecd7bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e37401600283aa226e2d0fdcfd00093324baf502a1a2d4eddfd12d16d6ad7d9f"
  end

  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/5f/d4/e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902/fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "multi-key-dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/83/a9/ad5efdb48044b7a4045f0de1262262da746e02d0bedd8cb8725144f8736c/python-jenkins-1.8.1.tar.gz"
    sha256 "ff5f1d92539d903f869b02eaf2b1314447e6d6d78f767edcfdd92967d532b9c6"

    # setuptools patch to fix the conflict with jenkins-job-builder
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/08e835e/jenkins-job-builder/python-jenkins-1.8.1-setuptools.patch"
      sha256 "f3319463368d8ed133ade64e6a4c4f01a28d45e6993a38012a26be55d8d3e765"
    end
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  # setuptools patch, upstream bug report, https://storyboard.openstack.org/#!/story/2010842
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f4a0fb0/jenkins-job-builder/5.0.4-setuptools.patch"
    sha256 "35d06c1dbd44bd9cd36c188eaaddc846a4c64dbd5fc1fb1d3269e54de1f6e2b2"
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
