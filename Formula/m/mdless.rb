class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.0.15.tar.gz"
  sha256 "e0820114811a17c3da76579d1c2860d0387dd1f9e667c2275bce554d9a3ad4d2"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "f2d1fd5c0181bc16948fde1b556d51ac991202ff532a8291f4854a2f2c476bd1"
    sha256                               arm64_ventura:  "efbba2d3ddd79563cae4fedddbc7f2def688e87e0e79289dc3f3ed1c49787044"
    sha256                               arm64_monterey: "bb83341a0d7dbb34402fe1b5db947dd0956576d63628947757e9b6f987bd8129"
    sha256                               sonoma:         "7bb2a0c88cab4f6abb1d8a0bd26633aba3d7a95b1e45948fe0611d8998a8660d"
    sha256                               ventura:        "68528f701162bc0080864ca43dceefa2162b99b3b010f1ede809dbf4014104f5"
    sha256                               monterey:       "70a6a0a0466e8598d5a4cbd92da4994596778cfcf8f749208bac49bd9e09760c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e5333480e2db0d82da8f2357716c22a43fa086f9550854303420ff2dd70f7db"
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
