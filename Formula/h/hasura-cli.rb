require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.35.2.tar.gz"
  sha256 "9c7d9d3c7e92cb4a334914af7ce6a3a922ac503135157b1fb98fb65e3a8127a0"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "691abe91c0d8198682ff91919bc4ff2f101c72f6348cd890be40732bf2b0d83d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0ed4ee24e425c5788a2d566e9a754ec89404a99f84836c5ec8cf0a284aeabbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2010649e92015c66c84fd937eb6ef0b77f1c7e0fbabe20c3e23332b33adbf189"
    sha256 cellar: :any_skip_relocation, sonoma:         "952297632d3e61b1950351b27cb4fc377cb8fdf118a6e64734bad70eb108f00a"
    sha256 cellar: :any_skip_relocation, ventura:        "3bdcd154961f539ab258be5311421eb5d71e8969791d2310d442a1de166cb2cf"
    sha256 cellar: :any_skip_relocation, monterey:       "40589b9d28b10138bf5eb0a34b11b3dbab859958f4ece3fff392c46cd69d51a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f99ffbc65eb62541bf3359bc2d7cc2b956560f0162e38550f3b22d8b7bfb4e10"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags: ldflags), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
