require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.2.0.tgz"
  sha256 "0e24c1e1ba956b3f171d5d52cc0bdc67f010168edb5b26945c40c5033aacb2f0"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "21f691750f50065583fff5e4e09735c05aae9dce2a2d366ba5beeb27f083d1c3"
    sha256                               arm64_ventura:  "6b21f797cfbdd444053768c13bafc82e229511c8d32124dc851595a06dcd9417"
    sha256                               arm64_monterey: "9809b658afac6af33d98a899bd11a4f49bf406f1096b202f461c443aa97d5eb0"
    sha256                               sonoma:         "7c665b8d1439b5c3f1c8973f5d0fa8ef1ef37d4ef6178b89c2181640549fa8d0"
    sha256                               ventura:        "2afa868c59b6b28b837297d91b5b695da990f29bda152d5c0e875725f72e6c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc21544c9c673806ad9ab72119d5938026873671629ff6c75722569f3f543c4"
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
    assert_match version.to_s, shell_output("#{bin}/appium --version")

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "unknown command", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
