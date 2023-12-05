require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.2.3.tgz"
  sha256 "b2500aef1507b3b05dad2ed45cf890d3d56d6cd7a062a471787c1cc046d51f0c"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "68d65b5d5456af8363452ab72f81cc7b9da80e49ff52376dc041396bfdecf6c4"
    sha256                               arm64_ventura:  "d6bfa205ce0339c7631e980302ecbcfd40f751751232b66ef7649af359c5cc3b"
    sha256                               arm64_monterey: "9a923129ac4e0c41d47989d4cb7a0804dac64f3439246456b1168dd241ce1f74"
    sha256                               sonoma:         "a939aba9aa3ac56e9dbf30dd14573c78acd86770a6c1b32f5928c122027f053d"
    sha256                               ventura:        "cbc333a4ef800b036518be823461fa9e9b57c0d3ab456e85abf663594ee94066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ac50f1755d94cd8cf697ff02b41ef37a48f8b289a97b4b8958da6e5fd605d8"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete obsolete module appium-ios-driver, which installs universal binaries
    rm_rf libexec/"lib/node_modules/appium/node_modules/appium-ios-driver"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/appium-error.log"
    log_path var/"log/appium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}/appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}/appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}/appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}/appium --version")
  end
end
