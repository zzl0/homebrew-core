class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "be4e2e429dbbb5d7988f8641ad262bbbff1ebf356a347caf8be86d123e3f39b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c130323995f309008f98181798fa86a6acd4d7b85eb8d583c62b7ae4453fa22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e4c7354961ff645bac66e6daf3b013c6291bc33504302935e671abb8675a846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0b52384186c70cf891befd01688238a42ea2bd522cbb2dcc713d74e4adc6dad"
    sha256 cellar: :any_skip_relocation, ventura:        "b7469949b0d187c5e4c5f6e5853047505f5ac52a63acd65f5515772c35bfb7a9"
    sha256 cellar: :any_skip_relocation, monterey:       "377eb6732a743f7ea66895d7a5da27aa4ddd725f444b829ae7ab259403a3a4b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "18623ad1fd1296db0c51f7d3005c76ace156128e2d1166f2cf9c84f26079fcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2abc9c8e872fffa219e8808fd730e0034077b15d8717b448ac347afbb65f4b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
