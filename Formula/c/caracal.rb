class Caracal < Formula
  desc "Static analyzer for Starknet smart contracts"
  homepage "https://github.com/crytic/caracal"
  url "https://github.com/crytic/caracal/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "dcc8f8ebbede56c9f68e025f444ede4f5966dc6c1c2695f09f999cf8f26f26af"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/caracal.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # sample test contracts
    pkgshare.install "tests/detectors"
  end

  test do
    resource "corelib" do
      url "https://github.com/starkware-libs/cairo/archive/refs/tags/v2.2.0.tar.gz"
      sha256 "147204fd038332f0a731c99788930eb3a8e042142965b0aa9543e93d532e08df"
    end

    resource("corelib").stage do
      assert_match("controlled-library-call Impact: High Confidence: Medium",
                   shell_output("#{bin}/caracal detect #{pkgshare}/detectors/controlled_library_call.cairo " \
                                "--corelib corelib/src/"))
    end
  end
end
