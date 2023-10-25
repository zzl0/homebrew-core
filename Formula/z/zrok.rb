require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "b27c539d761ba1ba977c82cd77e99526f7f019958450a13ed6c27007cc014e3b"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb370b1e2150bf7dfeadd8ed8898a86e7db0f091317ea08183174ed89d15cc2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1e8a6a35a8690cbfbcc2302c3c590d3c6a5495e84641df0ec5197513c747b6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf50ebb9446cc62a1811f20ec332f36a187542654c03bb82246534492a0f660c"
    sha256 cellar: :any_skip_relocation, sonoma:         "89ea3c5bc5229473ad4bc91164f2dc12ab2fe7f0e1d27762c1522d133c26bba9"
    sha256 cellar: :any_skip_relocation, ventura:        "43e1305e79f4d14e419ebcfbfecd870d3fb38b6da38c3902f24dc734850c832f"
    sha256 cellar: :any_skip_relocation, monterey:       "9c6e287f99ee74eaac8b5bba97e7458570902eaf60a7e0e0889f499481cbd708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9ba3d8284d1622815bf0d0acbd75c8bdcda15209509fec7b46eabb9b1ef0e3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    ldflags = ["-X github.com/openziti/zrok/build.Version=#{version}",
               "-X github.com/openziti/zrok/build.Hash=brew"]
    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/openziti/zrok/cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~EOS
      v: 3
      maintenance:
        registration:
          expiration_timeout: 24h
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
