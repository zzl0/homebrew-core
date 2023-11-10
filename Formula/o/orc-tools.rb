class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.9.2/orc-tools-1.9.2-uber.jar"
  sha256 "25f5063535f0ed1f5bccad7fa614595b0f765e7569e3203ebb0074e79b86f167"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, sonoma:         "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, ventura:        "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, monterey:       "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, big_sur:        "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "226350e7cec7f6c8cb87a7e6ea6d6501a0cd2c68ed52eac7361b1acd670218c9"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
