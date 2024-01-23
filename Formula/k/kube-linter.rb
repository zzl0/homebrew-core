class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "02f49d8f615e8549a8bc690d9aac93fb4fde3deb4d0ad803c654ff19d70736c8"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7b414698b69f2a049c7bf436332f0f4382a9f79c02547d485c298cc1630d848"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7b414698b69f2a049c7bf436332f0f4382a9f79c02547d485c298cc1630d848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b414698b69f2a049c7bf436332f0f4382a9f79c02547d485c298cc1630d848"
    sha256 cellar: :any_skip_relocation, sonoma:         "a836bde28391dcd4043e9a948219f29513cd39778e267983a803dfc9d2292b3f"
    sha256 cellar: :any_skip_relocation, ventura:        "a836bde28391dcd4043e9a948219f29513cd39778e267983a803dfc9d2292b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "a836bde28391dcd4043e9a948219f29513cd39778e267983a803dfc9d2292b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14064f9edd1a79594d0bbb27e3ad8859cc669b12ca479bb59a600876e83785ee"
  end

  depends_on "go" => :build

  # support go1.21 build, upstream pr ref, https://github.com/stackrox/kube-linter/pull/696
  patch do
    url "https://github.com/stackrox/kube-linter/commit/1085300cc73a29961547c4507bd4acdb4f385c64.patch?full_index=1"
    sha256 "50ebde54ac0c69fb19ccd2d545c1ec079256bd5c15cdd4d9199bb2007f64a9c0"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
  end

  test do
    (testpath/"pod.yaml").write <<~EOS
      apiVersion: v1
      kind: Pod
      metadata:
        name: homebrew-demo
      spec:
        securityContext:
          runAsUser: 1000
          runAsGroup: 3000
          fsGroup: 2000
        containers:
        - name: homebrew-test
          image: busybox:stable
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
            requests:
              memory: "64Mi"
              cpu: "250m"
          securityContext:
            readOnlyRootFilesystem: true
    EOS

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
