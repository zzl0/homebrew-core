class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/1.0.37.tar.gz"
  sha256 "9bd58b26f681a275cccbb11d877fcb53a72622ae7150b15e0e3257e5bf179973"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1c84fd6dc15f20b531016bdc716143e0eb1b1e151248c18c8ce8fff89aa588c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1c84fd6dc15f20b531016bdc716143e0eb1b1e151248c18c8ce8fff89aa588c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1c84fd6dc15f20b531016bdc716143e0eb1b1e151248c18c8ce8fff89aa588c"
    sha256 cellar: :any_skip_relocation, ventura:        "f1c84fd6dc15f20b531016bdc716143e0eb1b1e151248c18c8ce8fff89aa588c"
    sha256 cellar: :any_skip_relocation, monterey:       "f1c84fd6dc15f20b531016bdc716143e0eb1b1e151248c18c8ce8fff89aa588c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1c84fd6dc15f20b531016bdc716143e0eb1b1e151248c18c8ce8fff89aa588c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6cf8a232b8103d07e58a6a6b503d16361cdd67fccf6e02f119fda92b8540b30"
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
