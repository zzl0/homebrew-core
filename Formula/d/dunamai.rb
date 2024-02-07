class Dunamai < Formula
  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/79/92/288901fe54e995673551f177f067d476df3596ba56c6d5e77143c3a0fda2/dunamai-1.19.1.tar.gz"
  sha256 "c8112efec15cd1a8e0384d5d6f3be97a01bf7bc45b54069533856aaaa33a9b9e"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bdf36da31343b2b1fbd16a11d8ee822a9769207163927b066478ad535ec6bf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "623ef3c20fbd5c99fd3d40f235cb79972b366952bd1e42d72bb86b7b2c75b4e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeaf6e4233ade353870c8a8b9cba0c41f4182d5672cbf558914b822236f82aa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "05ca3b47594995493ae9060913d67682f47892fcf23b2518bc36b9acfea19987"
    sha256 cellar: :any_skip_relocation, ventura:        "cad35d5fff9c893b62877166b98a67d65aea0e2924498458dcf10c8986c8758b"
    sha256 cellar: :any_skip_relocation, monterey:       "8a78ef790cac6b99445b13689b64e52370232973ec496cd7cf757c692398dbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85052e3983d05901270259344adc47719cc299c97ee844c486378eede8c0ae93"
  end

  depends_on "poetry" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
