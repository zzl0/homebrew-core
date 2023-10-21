class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.1/tika-app-2.9.1.jar"
  mirror "https://archive.apache.org/dist/tika/2.9.1/tika-app-2.9.1.jar"
  sha256 "ae6c37cf93a849453f53b03e7a0f7d21ccf1144ace31186f328761874597a759"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, ventura:        "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, monterey:       "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c4f3424c99b047b7efa897eb4928a23495b32f54fddd368a9b0cb0faa5f3a62"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.1/tika-server-standard-2.9.1.jar"
    mirror "https://archive.apache.org/dist/tika/2.9.1/tika-server-standard-2.9.1.jar"
    sha256 "4e38d309c9396892ae14b4337cdf13f90f83da81b3b8123d72fde08fea2120bd"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")
  end
end
