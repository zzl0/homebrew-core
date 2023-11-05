class Bao < Formula
  desc "Implementation of BLAKE3 verified streaming"
  homepage "https://github.com/oconnor663/bao"
  url "https://github.com/oconnor663/bao/archive/refs/tags/0.12.1.tar.gz"
  sha256 "1565b3a8d043b485983ffa14cb2fbd939cca0511f7df711227fc695847c67c01"
  license any_of: ["Apache-2.0", "CC0-1.0"]
  head "https://github.com/oconnor663/bao.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bao_bin")
  end

  test do
    test_file = testpath/"test"
    test_file.write "foo"
    output = shell_output("#{bin}/bao hash #{test_file}")
    assert_match "04e0bb39f30b1a3feb89f536c93be15055482df748674b00d26e5a75777702e9", output

    assert_match version.to_s, shell_output("#{bin}/bao --version")
  end
end
