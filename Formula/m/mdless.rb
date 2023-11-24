class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.0.8.tar.gz"
  sha256 "9c2bb27a094b3b8d41c84ef58edbeccd328dda0d568315e29702fccf5da86956"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "d1c7bdb6fa403b3d1e8476951eeb2992cd1f60a294eb9e3fd4ac90cef7b3eba6"
    sha256                               arm64_ventura:  "453cb339cf28a03ea77738cce83d8d3e396e8b977ceae2ea0c6c75c791fb4ca4"
    sha256                               arm64_monterey: "e66996a10016719ce806cc8af281ba0278e7f58a27c8be3d7092a2758196e166"
    sha256                               sonoma:         "84e2b9a57835148e85d2681834e1e5b1a2da0347130c0721ec9c9eeb6c7b64b1"
    sha256                               ventura:        "47da4ee6d66e01ca1cfcdeabcee53698704c98f454bcf46e9bd38d0d6a44873f"
    sha256                               monterey:       "0abb9447647913af6d4f22c71b1dc58c8627ea2736e0b7c0cf97f7814390ae7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83277bd83d2a23b1f092d6afc8ab5f553e10241ba3f64d74334436c6714ade21"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
