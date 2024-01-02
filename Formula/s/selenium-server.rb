class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.16.0/selenium-server-4.16.1.jar"
  sha256 "ad85c1d732a89226266366d24867121ece11da85b0c4de0f9acb31d1a13b4775"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, sonoma:         "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, ventura:        "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, monterey:       "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38ffaaa85b8a3a278f72fcc4b90bc4b6f3e20c7781bba976fcd0f39df4b1e4ac"
  end

  depends_on "openjdk"

  def install
    libexec.install "selenium-server-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-#{version}.jar", "selenium-server"
  end

  service do
    run [opt_bin/"selenium-server", "standalone", "--port", "4444"]
    keep_alive false
    log_path var/"log/selenium-output.log"
    error_log_path var/"log/selenium-error.log"
  end

  test do
    port = free_port
    fork { exec "#{bin}/selenium-server standalone --selenium-manager true --port #{port}" }

    parsed_output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--silent", "localhost:#{port}/status")
      next unless $CHILD_STATUS.exitstatus.zero?

      parsed_output = JSON.parse(output)
      break if parsed_output["value"]["ready"]
    end

    assert !parsed_output.nil?
    assert parsed_output["value"]["ready"]
    assert_match version.to_s, parsed_output["value"]["nodes"].first["version"]
  end
end
