class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "4e1b3b01ef3dd590b1201a84d63b275ab65ce145793a1d15b57cfaa2149d3791"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_predicate testpath/"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
