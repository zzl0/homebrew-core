class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "5ba7ff3654b229a44684f473725dd7256e0514926fa553fbccfa556e399b3c3e"
  license "AGPL-3.0-only"

  depends_on "go" => :build
  depends_on "truffle" => :test
  depends_on "crytic-compile"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"medusa", "completion", shells: [:bash, :zsh])
  end

  test do
    system "truffle", "init"

    # medusa does not appear to work with 'shanghai' EVM targets yet, which became the
    # default in solc 0.8.20 / truffle 5.9.1
    # Use an explicit 'paris' EVM target meanwhile, which was the previous default
    inreplace "truffle-config.js", %r{//\s*evmVersion:.*$}, "evmVersion: 'paris'"

    (testpath/"contracts/test.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract Test {
        function assert_true() public {
          assert(true);
        }
        function assert_false() public {
          assert(false);
        }
      }
    EOS

    fuzz_output = shell_output("#{bin}/medusa fuzz --target #{testpath} --assertion-mode --test-limit 100")
    assert_match(/PASSED.*assert_true/, fuzz_output)
    assert_match(/FAILED.*assert_false/, fuzz_output)
  end
end
