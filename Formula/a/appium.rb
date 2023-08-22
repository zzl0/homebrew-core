require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.1.1.tgz"
  sha256 "f237198ce0d4d5410faf1d8bb0908483a4bd9c7606959835490c86055d87cefc"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "40b47f8617f606977258b6c365c00a703641dd0dd3ececb1a3361de7182d1f92"
    sha256                               arm64_monterey: "656bf4d253fe28e54e5f2770e47188afb2e6f507840383f6788e72ccfe2b441c"
    sha256                               arm64_big_sur:  "138a4d399e09d002c00e07e5d08579d552f8a0c4720ee703052b0cb06f4f0ee3"
    sha256                               ventura:        "af2f4e927b75115f2916d1f153f3346d3a1ac5e04b91ae4a3b567b1face99c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b47f0dd464f9e749ad0187b51cbb5ac1d8a53e1b05674b0a8e026f0fdcc6e1e8"
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
