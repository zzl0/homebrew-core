class Nbdime < Formula
  include Language::Python::Virtualenv

  desc "Jupyter Notebook Diff and Merge tools"
  homepage "https://nbdime.readthedocs.io"
  url "https://files.pythonhosted.org/packages/12/ae/4c403b94984adaa3859a829d1b99e2bd8cf65c06c6cb950111467d4cbb39/nbdime-3.2.1.tar.gz"
  sha256 "31409a30f848ffc6b32540697e82d5a0a1b84dcc32716ca74e78bcc4b457c453"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4058c573e6b60df940e22505192701b98ba488ba983c8863df27269c5bd77bc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca594667a33afc96a1f60a881079f3d242102b4a70a1b56347f012f330d77c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c097270ebb2a966b80d5ab25f6c54d778dd1c32784a926067d62c28738f8074"
    sha256 cellar: :any_skip_relocation, ventura:        "9d5c5e622c240ea2105ecbc6fbc6aaa0ec49c463b582fd7178967e896368d2b6"
    sha256 cellar: :any_skip_relocation, monterey:       "466fc9452217ec92c44a36e4778b8a9a815a28c9a9e368152086b10ad1b5b259"
    sha256 cellar: :any_skip_relocation, big_sur:        "e08a0bddfabc6e2bc5edcecf3902136a86d81684d466a1e9f730fd90de5e5bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cbb6c91ae3de21780272ed347387e4cedae6876689da4f97fc0beaae7d9044f"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "jupyterlab" # only to provide jupyter-server and nbconvert
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/f6/7e/74206b2ac9f63a40cbfc7bfdf69cda4a3bde9d932129bee2352f6bdec555/GitPython-3.1.34.tar.gz"
    sha256 "85f7d365d1f6bf677ae51039c1ef67ca59091c7ebd5a3509aa399d4eda02d6dd"
  end

  resource "jupyter-server-mathjax" do
    url "https://files.pythonhosted.org/packages/9c/40/9a1b8c2a2e44e8e2392174cd8e52e0c976335f004301f61b66addea3243e/jupyter_server_mathjax-0.2.6.tar.gz"
    sha256 "bb1e6b6dc0686c1fe386a22b5886163db548893a99c2810c36399e9c4ca23943"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def python3
    "python3.11"
  end

  def install
    inreplace "pyproject.toml",
      'requires = ["jupyterlab~=3.0", "setuptools>=40.8.0", "wheel"]',
      'requires = ["setuptools>=40.8.0", "wheel"]'

    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    paths = %w[jupyterlab].map do |p|
      "import site; site.addsitedir('#{Formula[p].opt_libexec/site_packages}')"
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    (testpath/"old.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": null,
         "metadata": {},
         "outputs": [],
         "source": [
          "print(\\"Hello World!\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    (testpath/"new.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": 1,
         "metadata": {},
         "outputs": [
          {
           "name": "stdout",
           "output_type": "stream",
           "text": [
            "Hello World!\\n"
           ]
          }
         ],
         "source": [
          "print(\\"Hello World!\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    # sadly no special exit code if files are the same
    diff_output = shell_output("#{bin}/nbdiff --no-color old.ipynb new.ipynb")
    assert_match "nbdiff old.ipynb new.ipynb", diff_output
    assert_match(/--- old.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
    assert_match(/\+\+\+ new.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
  end
end
