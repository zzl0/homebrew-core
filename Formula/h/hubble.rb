class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "57030eb5ea26d33fc24a089e21d46444b7fa3df50856e5f56ffe801cbeee26d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bcda3eba4f91432634bdfc2f0f4a8330f6fcb65a3e95251e6163bd1d51c3947"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "068387bd6e64e7560ec7e7f232a32ecc3ab12c396f077a86ee32cf1b8277746c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c81a9f3d920555feba8faca4935ad2de67ffff3164735353bd63e3f7defcb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3238cfe128399ee733bbf574e40973837513ed73223fe4b48e28f20c13298a49"
    sha256 cellar: :any_skip_relocation, ventura:        "3f62b1ebf9053467f56b7f8deaee0d1b32a75dde1a7e34bd2ea98ad28b553292"
    sha256 cellar: :any_skip_relocation, monterey:       "d90a6e2765fbff73c57a6d21d4229a96bbdaaad0f3a1edcee2721bb3a0b2d000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50d4dabd073b1e5a166fc0cc8c3fc824a8f750e5c1bd182f553fd8406262516"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
