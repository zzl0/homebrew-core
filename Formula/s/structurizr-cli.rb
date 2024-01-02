class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/2024.01.02/structurizr-cli.zip"
  sha256 "cb904943baa6a273158d03d8e527026fff34fc71a9b4cd9a7cc0c4377f13179d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3cb11b6e1eb0a965cc93207309bc0db8b47c709317519765d10522cfb664b41b"
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
