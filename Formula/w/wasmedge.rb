class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.13.5/WasmEdge-0.13.5-src.tar.gz"
  sha256 "95e066661c9fc00c2927e6ae79cb0d3f9c38e804834c07faf4ceb72c0c7ff09f"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  # llvm is required on run-time, as WASMEDGE_LINK_LLVM_STATIC defaults to OFF.
  # The version is pinned to 16 due to https://github.com/WasmEdge/WasmEdge/pull/2878
  depends_on "llvm@16"

  def install
    ENV["LLVM_DIR"] = Formula["llvm@16"].opt_lib/"cmake"
    ENV["CC"] = Formula["llvm@16"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm@16"].opt_bin/"clang++"
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # sum.wasm was taken from wasmer.rb
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmedge --reactor #{testpath/"sum.wasm"} sum 1 2")
  end
end
