require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.165.0.tgz"
  sha256 "905a0bb18424589da58623b52c9c4a1ae7bb0e4ccd586a1d732f7216c7cf8df4"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4743ba48338f09f01368761bf78407e5f6a7d08b839b1ebf8bad0e0c607c689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4743ba48338f09f01368761bf78407e5f6a7d08b839b1ebf8bad0e0c607c689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4743ba48338f09f01368761bf78407e5f6a7d08b839b1ebf8bad0e0c607c689"
    sha256 cellar: :any_skip_relocation, sonoma:         "806e613bef25688b9a2a82f4d7ca404a362640e590a56f33584103185003f2df"
    sha256 cellar: :any_skip_relocation, ventura:        "806e613bef25688b9a2a82f4d7ca404a362640e590a56f33584103185003f2df"
    sha256 cellar: :any_skip_relocation, monterey:       "806e613bef25688b9a2a82f4d7ca404a362640e590a56f33584103185003f2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4743ba48338f09f01368761bf78407e5f6a7d08b839b1ebf8bad0e0c607c689"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
