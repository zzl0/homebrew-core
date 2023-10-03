class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.15.1.tar.gz"
  sha256 "a6ca07877da3ad508305ba13ea5cabb595245fc3c916a83af6903334682f94ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe5deb87cf881ff09458a1fc8f6a48864dc256a0d19e1e75ca63f5f1d0f308c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f6df1cf2680e0d3ff0f62d10606ba1dba29cca28620719cef3da6005a5d27f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81264d0432db51283d8905ea03db0f888d150c157ced327c4091642990233411"
    sha256 cellar: :any_skip_relocation, sonoma:         "6250df0ed92dd39920d32b41c0a647a6633d9bb0d3079736587a69d2dd429d4c"
    sha256 cellar: :any_skip_relocation, ventura:        "662f51a24affb105069214323c94ed14be625d59c3d54c866aedffdf5edc6078"
    sha256 cellar: :any_skip_relocation, monterey:       "49227d48f68fb547ae3f35bbf4c7aab2b1183c1a0cf25556e7cd02b2058b793d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961667dd48d65ac7b841a1318fa4baee636c46b68e7ba357903fffe361e90090"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
