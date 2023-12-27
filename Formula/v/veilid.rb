class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.2.5/veilid-v0.2.5.tar.gz"
  sha256 "167c9a140aadc69d02a292d79edf949027d70a02985a860f0068adef914341df"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  # TODO: Remove `capnp` dependency once version >v0.2.5
  depends_on "capnp" => :build
  # TODO: Remove `protobuf` dependency once version >v0.2.5
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "veilid-cli")
    system "cargo", "install", *std_cargo_args(path: "veilid-server")
  end

  test do
    require "yaml"
    server_config = YAML.load(shell_output(bin/"veilid-server --dump-config"))
    assert_match "server.crt", server_config["core"]["network"]["tls"]["certificate_path"]
    assert_match "Invalid server addres", shell_output(bin/"veilid-cli --address FOO 2>&1", 1)
  end
end
