class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "1ab3ede256d4f0fba965ad15c0446a48ff61524ef27d3a1067916b1359568778"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30b6e5e29a48900173be30a6679266003c715e8d41110c92daa17f023b83bb15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20823bbe25a5b30850d2a17541e13be3183bfed6b1a7663d26289e01b3f602df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "043567f53d1e654917044068802cea839095a678652f974d33ddfdf43e11a053"
    sha256 cellar: :any_skip_relocation, sonoma:         "37b191c0098e213008aad1d0acd9e0ed49b8f167e7381da08a78f9ad31845747"
    sha256 cellar: :any_skip_relocation, ventura:        "9f7111863be97057f292445f80f3b8f2dceee74ace3bba27cccbaec0076e69ad"
    sha256 cellar: :any_skip_relocation, monterey:       "3976e74ee6d82bf4d7f4e7b03d86d948a85f54410d593cbab78ab4c0d2183a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4493835b024aa36cb767dfeba618f76c53c7365f58285184a430838d60a8e29f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
