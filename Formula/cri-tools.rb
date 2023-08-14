class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.28.0.tar.gz"
  sha256 "e32eb97d8ab6dff4a772a9672a19b62b65dd3bd71253aee64ba3d5109e86e058"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe1262227b7f4ea848bd9455c1cc724c764b62e64e8c6315daff217830e6c771"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe1262227b7f4ea848bd9455c1cc724c764b62e64e8c6315daff217830e6c771"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1262227b7f4ea848bd9455c1cc724c764b62e64e8c6315daff217830e6c771"
    sha256 cellar: :any_skip_relocation, ventura:        "ec2d75ad41bfa42a63df17944843ec9cfcce58f644ef1f89c4cbbc10671eeaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "ec2d75ad41bfa42a63df17944843ec9cfcce58f644ef1f89c4cbbc10671eeaf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec2d75ad41bfa42a63df17944843ec9cfcce58f644ef1f89c4cbbc10671eeaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48616fa492cdfbe75437d8db3fdbd30b2c338bdd70eff7ad3cc5cecdf2382ed2"
  end

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    generate_completions_from_executable(bin/"crictl", "completion", base_name: "crictl")
  end

  test do
    crictl_output = shell_output(
      "#{bin}/crictl --runtime-endpoint unix:///var/run/nonexistent.sock --timeout 10ms info 2>&1", 1
    )
    error = "transport: Error while dialing: dial unix /var/run/nonexistent.sock: connect: no such file or directory"
    assert_match error, crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
