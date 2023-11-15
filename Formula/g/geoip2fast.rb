class Geoip2fast < Formula
  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/96/c3/2abed46ccfec1f1c875d8f8e841e6bbaf33c471ccdfac12f559db70d17a2/geoip2fast-1.1.8.tar.gz"
  sha256 "e24f578ceae8dd6d56c7b625f7c82f66d70fd2300df1b30e10b4e3c797ccf9ae"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

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
