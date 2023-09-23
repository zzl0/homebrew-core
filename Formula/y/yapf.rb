class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/b9/14/c1f0ebd083fddd38a7c832d5ffde343150bd465689d12c549c303fbcd0f5/yapf-0.40.2.tar.gz"
  sha256 "4dab8a5ed7134e26d57c1647c7483afb3f136878b579062b786c9ba16b94637b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c19c4e9d28745f25fc4b32bd3f47b8d3a038c8ab1ee05c9c56ade537850df79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80bba73a25b7c33436b8b4d2cd807b05a45de6290f74ac562577c0304451f2e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ff81bd6bc8d793242886ec13d025b1ab941bf92f6dd6cb7fc0e39643107108"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75a0982a9845c4a81f5e49570da98be6582e873db542a93a5b920acdf1af1c50"
    sha256 cellar: :any_skip_relocation, sonoma:         "fda284ecb54448f9990b5d997d285284824feba8ff2b8ff7b4578991285c8d73"
    sha256 cellar: :any_skip_relocation, ventura:        "c8bad7425f63d9b777a998250d915c164dff024d7e97af3a46477e42d82dd044"
    sha256 cellar: :any_skip_relocation, monterey:       "a350dc2c0ff2519996bc8f5d6f04668dcb771d5dafe3726029967cbac3997e72"
    sha256 cellar: :any_skip_relocation, big_sur:        "e32bed37cb71e4aea5e8da2274e5598573d7b241794ae788fe2b08139c3ee14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a7d59dc90febc7fd4f1db1aa07d9336f628776520cbab88dad0bec55dfd7f8b"
  end

  depends_on "python@3.11"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
