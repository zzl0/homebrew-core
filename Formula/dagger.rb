class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.0",
      revision: "4fe49b534a8cc5bc37cbd17f4b4343d2c1868f8b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3db3f61859fd8af4fd6062582b16d16f545f9c44e1180a7b5883077dc302c34d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db3f61859fd8af4fd6062582b16d16f545f9c44e1180a7b5883077dc302c34d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3db3f61859fd8af4fd6062582b16d16f545f9c44e1180a7b5883077dc302c34d"
    sha256 cellar: :any_skip_relocation, ventura:        "1aeaabbaee33cf058603a733cefe638b9fef7336f4cc5d422f142ba77320e3ec"
    sha256 cellar: :any_skip_relocation, monterey:       "1aeaabbaee33cf058603a733cefe638b9fef7336f4cc5d422f142ba77320e3ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "1aeaabbaee33cf058603a733cefe638b9fef7336f4cc5d422f142ba77320e3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b007579af4d5b9afed2c6fa13591e68bb0a4c59042053c78077d2212370985be"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
