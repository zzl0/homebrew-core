class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https://github.com/prompt-toolkit/pyvim"
  url "https://files.pythonhosted.org/packages/c3/31/04e144ec3a3a0303e3ef1ef9c6c1ec8a3b5ba9e88b98d21442d9152783c1/pyvim-3.0.3.tar.gz"
  sha256 "2a3506690f73a79dd02cdc45f872d3edf20a214d4c3666d12459e2ce5b644baa"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "607912e14bc5faf751a28fd3727752a9f4f7695dd767cb8dea31ecf63cf09334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84271d72d5e192730afe696ff8befbd09ed45c9ebb495fdc2a5675ef9e363f32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6998e350ae758b15aa2db8198001bc8a8124ed1c86a74e32ff3901359bb193b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c15aa998f7b3961dd042fd1e32bf09eb59510dd1774e348ceb4d297a36cf09"
    sha256 cellar: :any_skip_relocation, sonoma:         "84746289c8f29cf62f3d5699056c12683b451153fb01affc4b09a20ef8a9dd2c"
    sha256 cellar: :any_skip_relocation, ventura:        "e2971047d47ad67e4a6a28afac14094a5dc6addf200880b24607da3730b46618"
    sha256 cellar: :any_skip_relocation, monterey:       "8968b45fc990d804c0fb406dcfd19f5a459e0a65bf06152c763bc5d9a147c4d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ea53ff35fdcdace23d6d95d67ddae50da86b64e63cac5a4796235f24df404b2"
    sha256 cellar: :any_skip_relocation, catalina:       "1a18a3f4743b90fc41e4fad362eaf4a5fbb050874ab6fcebf61058ceb014d12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709d795900c4098c90892135c0859c0c93f8aa18868eeeb023bc4357bace19b6"
  end

  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/8b/fb/7251eaec19a055ec6aafb3d1395db7622348130d1b9b763f78567b2aab32/pyflakes-3.1.0.tar.gz"
    sha256 "a0aae034c444db0071aa077972ba4768d40c830d9539fd45bf4cd3f8f6992efc"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Need a pty due to https://github.com/prompt-toolkit/pyvim/issues/101
    require "pty"
    PTY.spawn(bin/"pyvim", "--help") do |r, _w, _pid|
      assert_match "Vim clone", r.read
    end
  end
end
