class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "6d40cd2bb9d0eee1b3637f14c9642009a4917e2c73177b4584de6bd0d8632391"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
