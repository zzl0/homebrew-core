class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.0.4.tar.gz"
  sha256 "b0be56b7337f645181e124ec51faba84f6f349a2b5b0694fe6beaeb88083601f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, ventura:        "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5e20dc35f8c5fac99066e982b12842e50e66859c539c020a2c05b49e13dff5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74689bfcf5f62937fffa69da30455f66ac2147ce80118f5aa17acdba93d10d0e"
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
