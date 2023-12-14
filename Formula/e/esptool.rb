class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/1b/8b/f0d1e75879dee053874a4f955ed1e9ad97275485f51cb4bc2cb4e9b24479/esptool-4.7.0.tar.gz"
  sha256 "01454e69e1ef3601215db83ff2cb1fc79ece67d24b0e5d43d451b410447c4893"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eaac4e9cee2bb19e4f51b2d33cbdfeb0f0241afeba929d8ae9fa50098a57f14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c20791ca0cfdf081f5db8f3503186f1a3032563f41bf21275112a2c28127d276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3891c7ae07a41b8b447dad70bf04ca8e61c67459177bee8389b5d5d0c23ea209"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7595afb62aebbdc31195b1a6ba118f5949b6f2b27bf7f9a30fd3b23b482ad78"
    sha256 cellar: :any_skip_relocation, ventura:        "a476d04cf47f91ff9313c643675e4261afcabbd5da000c1006896707cffb15ee"
    sha256 cellar: :any_skip_relocation, monterey:       "fb19b0eb41d90a07423fa2154d5aa0571de1390e30b028804234e447aa40d1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "740e2f07e494eea1ae176b50b01b7419c7aa813d08efa19655d80978e0fd752b"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/2e/7b/31d117a213a0a42a5c5f48bab3e5786b98952d243022d43727f379db0e16/bitarray-2.8.5.tar.gz"
    sha256 "b7564fd218cc4479f7f0106d341e096f78907b47865aeeff702c807df1927c01"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/7f/07/0fd502a29127b968bada3d1824a8af997546d2b9ff73f00e800b3d9888cb/bitstring-4.1.4.tar.gz"
    sha256 "94f3f1c45383ebe8fd4a359424ffeb75c2f290760ae8fcac421b44f89ac85213"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "usage: espefuse.py", shell_output("#{bin}/espefuse.py --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
