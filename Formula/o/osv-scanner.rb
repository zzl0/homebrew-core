class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ea306347840c0c24e11061b74d0045f99179d7764e944896b9137fa49352e903"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "792e7ce252cc396cd2138af129f0d76c2c0da557af085a6b4a522a8d257adbf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792e7ce252cc396cd2138af129f0d76c2c0da557af085a6b4a522a8d257adbf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "792e7ce252cc396cd2138af129f0d76c2c0da557af085a6b4a522a8d257adbf8"
    sha256 cellar: :any_skip_relocation, ventura:        "7b19d81f08a5f5e3557d038acecd2f5ae4095856ac1e5640bca39da67a63564d"
    sha256 cellar: :any_skip_relocation, monterey:       "7b19d81f08a5f5e3557d038acecd2f5ae4095856ac1e5640bca39da67a63564d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b19d81f08a5f5e3557d038acecd2f5ae4095856ac1e5640bca39da67a63564d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a87a7bbf5008320eb1eccba4dac980ede6fea533724818be03b76dbbd91ac2"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 2 packages
      No vulnerabilities found
    EOS
    assert_equal expected_output, scan_output
  end
end
