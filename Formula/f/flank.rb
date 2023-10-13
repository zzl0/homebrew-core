class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.10.0/flank.jar"
  sha256 "8b22a99abb6d14c3e7a908f2ce89fa4aeb6b6776890ef916fa8d2c40774aa6c6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e12b1c3caea2a6e0a4283f86b486fe16286b505d2ef9020b8f9879907ad7793"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f61019aaf6202342f09854bf6213643aedab3b400ce0ab0349f5084f36d04446"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f61019aaf6202342f09854bf6213643aedab3b400ce0ab0349f5084f36d04446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f61019aaf6202342f09854bf6213643aedab3b400ce0ab0349f5084f36d04446"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e12b1c3caea2a6e0a4283f86b486fe16286b505d2ef9020b8f9879907ad7793"
    sha256 cellar: :any_skip_relocation, ventura:        "f61019aaf6202342f09854bf6213643aedab3b400ce0ab0349f5084f36d04446"
    sha256 cellar: :any_skip_relocation, monterey:       "f61019aaf6202342f09854bf6213643aedab3b400ce0ab0349f5084f36d04446"
    sha256 cellar: :any_skip_relocation, big_sur:        "f61019aaf6202342f09854bf6213643aedab3b400ce0ab0349f5084f36d04446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64213bd9bbdad0729562540f8a41ddf691330ebdf343757734bb443a5ff7b575"
  end

  depends_on "openjdk"

  def install
    libexec.install "flank.jar"
    bin.write_jar_script libexec/"flank.jar", "flank"
  end

  test do
    (testpath/"flank.yml").write <<~EOS
      gcloud:
        device:
        - model: Pixel2
          version: "29"
          locale: en
          orientation: portrait
    EOS

    output = shell_output("#{bin}/flank android doctor")
    assert_match "Valid yml file", output
  end
end
