class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.279.tar.gz"
  sha256 "e05795cb66d79add8306274b3d67e694d299bd9d09178385b857dc58414381d8"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05c050887ab31ff84f140dee19f382c5a0cbacb8388492d6e19de8b3cb94642f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "114f452635df0db5788ab59e19872824a996fba639970534ca7bdaf9a1493636"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bcc9dbd8036024f248ca954112a64e40c0843d7dbcdefb4ddd846073a46b59b"
    sha256 cellar: :any_skip_relocation, sonoma:         "21390ec82153043461b3c4d48ed34a95025ec394dac080d623a99c74975b7b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "f1b17f7ac5c020158e42c334d227b5932f7584c55646914379ceb2ea83a8126c"
    sha256 cellar: :any_skip_relocation, monterey:       "4545ceacc5a5a96445a65f7fa7f0ff77edeabbf5dc45ff5ac2e5eeb6b3cc5c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889c17fd07623d32f47e88866ebab8e6d916851694f32de6d67dba1ee6a8203f"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  # build patch to support go1.21 build, upstream pr ref, https://github.com/werf/werf/pull/5931
  patch do
    url "https://github.com/werf/werf/commit/cf07a1a90022188ec40bf5d3cdc70855ee475ef5.patch?full_index=1"
    sha256 "112876536e7a8887e9e307773790ebb56c009f44cf1b75719a240ff280431093"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
