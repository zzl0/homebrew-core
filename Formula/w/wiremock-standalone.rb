class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.3.0/wiremock-standalone-3.3.0.jar"
  sha256 "c59d92ce979bbad359ee5e402eebfe362d083da97e82e995ddda94b0aca828da"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e5d05fc7296c2d3bcc7f222048d70763883bdb4fd528811d0145c00445e6ba9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e5d05fc7296c2d3bcc7f222048d70763883bdb4fd528811d0145c00445e6ba9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e5d05fc7296c2d3bcc7f222048d70763883bdb4fd528811d0145c00445e6ba9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e5d05fc7296c2d3bcc7f222048d70763883bdb4fd528811d0145c00445e6ba9"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5d05fc7296c2d3bcc7f222048d70763883bdb4fd528811d0145c00445e6ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "4e5d05fc7296c2d3bcc7f222048d70763883bdb4fd528811d0145c00445e6ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a268c0e7f8b13359e9add5dc7d9ad1af83b94b62d505a9abed66a3de978afaf5"
  end

  depends_on "openjdk"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-standalone-#{version}.jar", "wiremock"
  end

  test do
    port = free_port

    wiremock = fork do
      exec "#{bin}/wiremock", "-port", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/__admin/", "-X", "GET")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/__admin/shutdown", "-X", "POST"

    Process.wait(wiremock)
  end
end
