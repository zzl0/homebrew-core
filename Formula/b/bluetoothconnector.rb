class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/refs/tags/2.1.0.tar.gz"
  sha256 "cbb192e5f94da27408bd8306a25e11bbffd643d916f6a03d532f83a229281f77"
  license "MIT"
  head "https://github.com/lapfelix/BluetoothConnector.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cd15761ad7178b940468d448f24418c3adb3888f122b36acb3258b4abb76a11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b37f1ec5f2a36af25b4156b5d5abe9a43e7e541a6353075798e8daf523312deb"
    sha256 cellar: :any_skip_relocation, monterey:       "7a6ab5b2d1c09fb0ed36ca64fda21bd8cb29ef08096d85ecb34049c80947fa98"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b1be2b35a5d442e3874c82ebe2c37ff5ac22478d561cf28effc8110475f3bc4"
    sha256 cellar: :any_skip_relocation, catalina:       "38d8b5c89fd8fee4a746eadaceb399d5b7e1148db2cee896381b6e093aef56e3"
    sha256 cellar: :any_skip_relocation, mojave:         "1a0c1e83b5640a35c48ba982f1b7cf5b1bebdda6fd4957368262c3e001c740e3"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    shell_output("#{bin}/BluetoothConnector", 64)
    output_fail = shell_output("#{bin}/BluetoothConnector --connect 00-00-00-00-00-00", 252)
    assert_equal "Not paired to device\n", output_fail
  end
end
