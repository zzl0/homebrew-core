class Modsurfer < Formula
  desc "Validate, audit and investigate WebAssembly binaries"
  homepage "https://dev.dylibso.com/docs/modsurfer/"
  url "https://github.com/dylibso/modsurfer/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "61d343518c3b11e3c0496f37553e716a0e213cb711dff65d92cc682a7efd0e01"
  license "Apache-2.0"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/modsurfer -V")

    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)

    system "#{bin}/modsurfer", "generate", "-p", "sum.wasm", "-o", "mod.yaml"
    assert_path_exists testpath/"mod.yaml"
    system "#{bin}/modsurfer", "validate", "-p", "sum.wasm", "-c", "mod.yaml"
  end
end
