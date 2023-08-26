class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/e0/8a/9be661f5400867a09706e29f5ab99a59987fd3a4c337757365e7491fa90b/autopep8-2.0.4.tar.gz"
  sha256 "2913064abd97b3419d1cc83ea71f042cb821f87e45b9c88cad5ad3c4ea87fe0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ce007a85b838db399b9167314beb7211f5ee30da359ff9ca8378b1c2d38764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e49e1c1bfa25caa7aa2966b0b33a324bf209e16c8c413bc449e479339d1c50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5da9805272a28694edb64c77cb8cf64f63122d630978679ffb40743c8071c091"
    sha256 cellar: :any_skip_relocation, ventura:        "03ca99c82e9994a214b54c1c65bd6fba8847b4d164d3f69c12dfc17f7d9fccdf"
    sha256 cellar: :any_skip_relocation, monterey:       "db46bcdec6bed1ac12f07402d942355e82d447cc8dd0a8eeb48ffd12a7611a92"
    sha256 cellar: :any_skip_relocation, big_sur:        "4be9b05b14a2fb72461b1accf244cda09ffa3d72e091c0990796f084a7dd1137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e6ed4d02e21f935a2848c35674e777ce68200e046863bff20573f87974fa2b"
  end

  depends_on "python@3.11"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/c1/2d/022c78a6b3f591205e52b4d25c93b7329280f752b36ba2fc1377cbf016cd/pycodestyle-2.11.0.tar.gz"
    sha256 "259bcc17857d8a8b3b4a2327324b79e5f020a13c16074670f9c8c8f872ea76d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
