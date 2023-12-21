class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.274.tar.gz"
  sha256 "6bdba2b9e0a15d25e823199e0a4d771b18fdcf5dbd7ad48525db0e2cf8af3b69"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2757dd26c16c3214bd848cb4753bd0e2a693525d023092e35be2a66d6225e3b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8e72e80fd49510f6228d03ae6a91d4de4dd95caa22f27ee13e6bd4d5ad342f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0144c6d6c10417ea71fc95e8b0a7bbba8e7d4ccef7e0922ea922fecf44f825ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef7e2e796fd3ac759f5c1fd1e05ee2b1a31f5a5d40f249e319c80e7d37e62069"
    sha256 cellar: :any_skip_relocation, ventura:        "069e5937e8e9effe491a7a271a7b10583e6a633642c1830b9b8f86304fd8684d"
    sha256 cellar: :any_skip_relocation, monterey:       "a703ca66f98c0976e69b8ac285ed4abdcf4c4e578236949ccc3e81c154ff399a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "196d7e56082bd57046cf61ee591b00371f2b368b9e184ad455873a05a27af890"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
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
