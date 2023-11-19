class Cherrybomb < Formula
  desc "Tool designed to valide your spec"
  homepage "https://blstsecurity.com"
  url "https://github.com/blst-security/cherrybomb/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "1cbea9046f2a6fb7264d82e1695661e93a759d1d536c6d1e742032e4689efe9f"
  license "Apache-2.0"
  head "https://github.com/blst-security/cherrybomb.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "homebrew-testconfig" do
      url "https://raw.githubusercontent.com/blst-security/cherrybomb/9e704e1cadd90c8a8a5be4e99e847dd144c68b0a/images/api-with-examples.yaml"
      sha256 "f7dc3d69f69ca11ae3e7e6ee702aff13fee3faca565033058d9fd073a15d9d45"
    end

    testpath.install resource("homebrew-testconfig")
    test_config = testpath/"api-with-examples.yaml"
    output = shell_output("#{bin}/cherrybomb --file=#{test_config} --format json")
    assert_match <<~EOS, output
      Starting Cherrybomb...
      Opening OAS file...
      Reading OAS file...
      Parsing OAS file...
      Running passive scan...
      Running active scan...
      No servers supplied
    EOS

    assert_match version.to_s, shell_output("#{bin}/cherrybomb --version")
  end
end
