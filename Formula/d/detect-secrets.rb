class DetectSecrets < Formula
  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 3
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0f10f63f00078cdcc21abdc6ef9e5963cdccae6724c58cafc2d7058794e5c74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5351cddc0d581fb6b5eb1f60a5357c30645027a9ce039392916a179bc000473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6fc1241cdecb1c606233601213e9f4c60bea6c49fb0cb2c6ebe51f6bfb10a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfec889b655d961d57142f0045dc7b0bdac364c44f08a579f9b2230e318638ba"
    sha256 cellar: :any_skip_relocation, ventura:        "972eb9dbad438ca34e4ae457259a8283e1b117c915d9a2364e57368fa3eac512"
    sha256 cellar: :any_skip_relocation, monterey:       "45d3fb2225100c7925cf55e419c6abbd4636ebcb0bfe78100e9ed74f12e04842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f82f3badb58be82303489ac06d9a57b350afdf5f19a250c57c8d3ebece8044f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
