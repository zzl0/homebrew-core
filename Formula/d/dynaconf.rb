class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/f3/11/a1cbc9bd1c07a5ef8254c969aa9f5549c8bc6bb38bbd369b2020df554bd1/dynaconf-3.2.3.tar.gz"
  sha256 "8a37ba3b16df64cb1db383eaad9c733aece218413be0fad5d785f7a907612106"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "979837ec3435b0de70d8c7016d92a4c6ecbfcd0a4b2924ec885924415c9fbd82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec89a25f9cad8bfc744e9dda0045445559616cecd2d89ee1588e487a30b271cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c1635666a5516a380b7be98b1a97e0d9902f9c6c73a0fe9b1d39a57ee3617b5"
    sha256 cellar: :any_skip_relocation, ventura:        "3c2c24c8966561a3700b610398b9ba0c258a444b45237eeff94367038fdb1e65"
    sha256 cellar: :any_skip_relocation, monterey:       "97d9607f01682037c1cf0259215932c2fee1ba37fa1f2d9ab817bdce9efe6368"
    sha256 cellar: :any_skip_relocation, big_sur:        "c18098e391fbe19ff2496e99ad2e4fc6d08d57d718915d5c2969afc9e3a25cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a9dd8b17c626a7320ee7a1f6a69fb8bff36ed2b199cbc1ed2b28c1c903b5dd2"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
