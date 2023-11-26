class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.35.0/structurizr-cli-1.35.0.zip"
  sha256 "caa1860d32bcafa792243fd62c0b41d6891fe20a9b7f35f1e7c3405dfb7554f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3e72624f951e92b0eb014cf056c82eca46b3343ce3a6916ae4d4b4f1f84bb18"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|version|help [options]", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
