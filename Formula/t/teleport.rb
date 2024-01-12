class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v14.3.2.tar.gz"
  sha256 "4c56899cda7456dbc6a7f5f7c1ec01dd20e1a4b7a4a2f8850ab5b56b7243bd86"
  license "AGPL-3.0-or-later"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8affa1eb644b647fd2bab6d8f8a6f1ec4a3ffd593d6926a7f8c6223a506552e1"
    sha256 cellar: :any,                 arm64_ventura:  "a2a089148c76a66e451408ab081f25da070ea56bf33333b0f7bab2773076759d"
    sha256 cellar: :any,                 arm64_monterey: "337d9c8d550207eb00873a28dc4d00923f588cc2a1ce9e279e946d6892a2ef52"
    sha256 cellar: :any,                 sonoma:         "5f43eb22834e7b494c6ebeac102816799ace15d2d9936db378aa3d1851a544db"
    sha256 cellar: :any,                 ventura:        "9b015eb086c5b840363690a4e9c85328838cb8b42a177aa2ee1636039bbe86f7"
    sha256 cellar: :any,                 monterey:       "eef24b778a470cd1cdced6ab8bf1aabfdfd57d15c85c552a18dac3de28ae71df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "707fca66c10f5a24500b22f40aed41561385a577a4c4aba0ea6aa2a14b43a450"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
