class Geoip2fast < Formula
  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/eb/34/6d91d8165b2d717736360c65a7822ccb025bca4cd0a1385982c49ce73b9e/geoip2fast-1.2.1.tar.gz"
  sha256 "75bb4cd4931c245c5aaecdac7e2d2a350689e1dba4a1a5371eef92263995adb2"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac573e3ec4d783f6a606f037534fe167c10f90ac410d8512489ff242a2b9cb37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7932b0d486bc03c1224a70548b3c648ca207ab8ecbf74982cfb53cbf9bbd7c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc6ff0f599a503da67621cf74a10c7dca971b33405caede141a744888e812d9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2df4f78616c37aca04d06c712ed2a33641b33df59a3e4ccdd5a457f5e82938fa"
    sha256 cellar: :any_skip_relocation, ventura:        "a4763ff033c5936691badd26686903bae14b889630cda3edd433ad62a856671d"
    sha256 cellar: :any_skip_relocation, monterey:       "50ae42815c3dd1b259f5525ee0c53a9076c5967e480ef8172002e3994b0ae599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2671c1558896dced9c83f2c6d258c9d2428b6d006c6e148118e0c919f1ac891e"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output1 = shell_output("#{bin}/geoip2fast --self-test")
    assert_match "GeoIP2Fast v#{version} is ready! geoip2fast.dat.gz loaded", output1

    output2 = shell_output("#{bin}/geoip2fast 1.1.1.1")
    assert_match "\"country_name\": \"Australia\",", output2
  end
end
