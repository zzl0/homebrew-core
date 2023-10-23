class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/f2/29/3e87b8c7fc9779bf216349ffcaed9a748928a015b77d71ab2e0dd1b4e073/badkeys-0.0.6.tar.gz"
  sha256 "ead74de1a60844bbd8019710aa8314ecde82ac077eee72d68a6f185e7ab5ee48"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  depends_on "cffi"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/a7/d1/249a57c014c3a73ffc842d5a33a1ce3d4198f3e6ea0ee84c237d24b5a556/gmpy2-2.2.0a1.tar.gz"
    sha256 "3b8acc939a40411a8ad5541ed178ff866dd1759e667ee26fe34c9291b6b350c3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/badkeys --update-bl")
    assert_match "Writing new badkeysdata.json...", output

    (testpath/"rsa-nprime.key").write <<~EOS
      Invalid RSA key with prime N.

      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAqQSg27883tGr5jtyOaZkEn597cuw1Wz4wWuFp1quvHOyiMId7L7m
      KHh2G+WQaEEBKl2A/M/tXgdfbrY0NnW3SMIZ9PMTWJNjtAqjBKVBDXDJbJhOpvya
      gL4HBKR6cnB0TE+3m0co6o98xRT7eFBP4V9WyZYIG15XDruFvGkgeqmXefqf5BB5
      Erquu6RePYNt25I3SFM12kZTW+HcrDyj34CO4Jxkw5JI5bUtP9wV5ocr/Z5FmvmI
      Di3eNbHBVteLN3BIuFax8JQvpcdwEjy7Qdro5Ad3a3Ld4//2Vn/mAkGPop/HmJme
      wI1poiKh+VgF87bloijO+izBYk/eo9ZWWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-nprime.key")
    assert_match "rsainvalid/prime_n vulnerability, rsa[2048], #{testpath}/rsa-nprime.key", output
  end
end
