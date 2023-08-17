class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "973a94a499c19c90f76624f9fc22d8a15b68fbb9565d74d237d4fb524bddf4ec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3777336eb86412a0d3504bc41de84d8e3b26e8e96f864e241639b5454f518d49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3777336eb86412a0d3504bc41de84d8e3b26e8e96f864e241639b5454f518d49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3777336eb86412a0d3504bc41de84d8e3b26e8e96f864e241639b5454f518d49"
    sha256 cellar: :any_skip_relocation, ventura:        "a649dc00e25dbeb8ab97111f9523fad7ea244f2bedc9a8e147755ad36c26404d"
    sha256 cellar: :any_skip_relocation, monterey:       "a649dc00e25dbeb8ab97111f9523fad7ea244f2bedc9a8e147755ad36c26404d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a649dc00e25dbeb8ab97111f9523fad7ea244f2bedc9a8e147755ad36c26404d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae27ed5eed674991b7dadf59e40bb42055f646262035b3a2c7c5db308d8410e8"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
