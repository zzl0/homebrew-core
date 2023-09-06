class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.3",
      revision: "2e8694d1c087e2b552c542d0218d9aa52f8dffb5"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ed2800dd63995ca3b88d423ae6c992efe86f0c1f820db8763a986fee23e5526"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f6e962bc1234fc9ac2c564c18fcc1a57d0c7ef1da9fd308fc868a1e1108eb81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55df510ab5eb569e377c6366d7e143577ed831e65d6b0c78d4bde2677b6338da"
    sha256 cellar: :any_skip_relocation, ventura:        "bb70c84052dc34ec190214359dc12b37cd91eaca2baffa8d5489d8bf8c7616d2"
    sha256 cellar: :any_skip_relocation, monterey:       "92b6ac10748f93777ec8aa63c5754da50b12a4bb903a2fbb382f40cb58250a9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "543ed59c2a63b49a539626b98cb169f88b8e790d0d377e92783fc339423cf8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cafcc48c25d58d6ebc855e34db7c9e72356f6395e3f53e165438585180c2ffd"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
