class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  # Upstreams tar.gz can't be opened by bsdtar on macOS
  # https://github.com/Homebrew/homebrew-core/pull/146296#issuecomment-1737945877
  # https://apple.stackexchange.com/questions/197839/why-is-extracting-this-tgz-throwing-an-error-on-my-mac-but-not-on-linux
  url "https://github.com/apache/avro.git",
      tag:      "release-1.11.3",
      revision: "35ff8b997738e4d983871902d47bfb67b3250734"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ea5f0b58805e405927762ab943ae04e8a2722d792925148e118b4331fe6384"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, sonoma:         "26ea5f0b58805e405927762ab943ae04e8a2722d792925148e118b4331fe6384"
    sha256 cellar: :any_skip_relocation, ventura:        "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c4dc1a7ac00b8a93c0e1b3dd863a3febd200481b1c181760e758b31b310e346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9d8acd4a357b1f9ee3eb77a8eb5db5bbd20cfd838c97de0474b86da031a64c"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    cd "lang/java" do
      system "mvn", "clean", "--projects", "tools", "package", "-DskipTests"
      libexec.install "#{buildpath}/lang/java/tools/target/avro-tools-#{version}.jar"
      bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
    end
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/avro-tools 2>&1", 1)
  end
end
