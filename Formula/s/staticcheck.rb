class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.4.tar.gz"
  sha256 "f112ab27150d654626ac26236d658ea7882f68ec23164827ef586ef1c4c4ce7c"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebebd2082c5dbcd2febffdd222cf03e7b8f26f173e21bfbd7c4377dcdefde69f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53dbb06e569cd5193d1704880b19a57db90b70c5447481b75f726e9555141495"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dadee762aa80bbbb98ebc1e19059da8151f9f6570cd4b621fdf53ac057741050"
    sha256 cellar: :any_skip_relocation, ventura:        "3e603300b567fc76aac9a5d648990feff1bff97f64809496235358b58625b2ac"
    sha256 cellar: :any_skip_relocation, monterey:       "5297a6e2cbc4aec6aa6950672b30e1d357788ff5ff12c3a04c866a73c0310091"
    sha256 cellar: :any_skip_relocation, big_sur:        "df528df77c5bf7ae657b600d228cea5c116fe1fd952b5ee1632a0e23d85557a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515055a7094e0eb9a78575a78128c2c3b726d02d2e428051605fe1e00ca6a3d8"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    EOS
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json test.go", 1))
    assert_equal json_output["code"], "S1021"
  end
end
