class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "e2f2ff85aeb4b60a6973ed03616de8977fbb0a40696b4fdb53405a7e9ddafe1b"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f4adf1b1ae2778bb60f88241847c19bde1466b6c06a4557e383264c628fed51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81e61c752ab69857f596c5c8f7fb2cc9d35221086f9dadd826bdd1860a409e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a97b861953d58e9d294ff87e9f16ade57eb0de10a1c372f13a47ce0ada6b6db"
    sha256 cellar: :any_skip_relocation, sonoma:         "980a6be6aaa83fe90570e5348a8c1db3e051bad73a73179a9a89aa5c8abc439c"
    sha256 cellar: :any_skip_relocation, ventura:        "56f37f4a3663d5d6e53c95541e69d2482cb7bdf6e1b57ba0dc8e163f324c1a69"
    sha256 cellar: :any_skip_relocation, monterey:       "24016b430fddb28ab30eb41ffae5c9a6682ea5d54f9693bda791b72c7de90bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac528045d58e57f52ed007ab230341b5be6b784743eef4214b2448509f38ada0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end
