class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.42.tar.gz"
  sha256 "c9f9a846eea7a6fdbbd82549197de1faee5ca84929a7d117202c2c774f6c262f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d808938e92139c3641c74220ce5301241c9e9286b278b7a1e0d4c1d78a7dca33"
    sha256 cellar: :any,                 arm64_ventura:  "aba4b17d841be49041c8ad31abf783c1c3ef9fe56309693211f49ceea02dd8ec"
    sha256 cellar: :any,                 arm64_monterey: "90e885feea23c65759126627f58fa22fecbc6eb7512fd2a22b2170a7bdb3bc1d"
    sha256 cellar: :any,                 sonoma:         "6c7efd2ae3c9e90d934986854444792691ba43d4ec25b8517a0fe6db73ec3cc7"
    sha256 cellar: :any,                 ventura:        "46598edde27ed6ee11632d618996764f1041587c752862ae9f51f03aac6c106b"
    sha256 cellar: :any,                 monterey:       "3af4c8c2f1c190f4d9e4b4cd231c1a3cbf002b5c6c195fbfa627bf04379b4fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74f628b89d25a03d2ebaebea01e84ee7f1f7e615ec8c02591417761c14a19178"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

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
