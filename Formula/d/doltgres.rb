class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "6d2458306755489f84ef6ac78bdf58f090511d2d3b099c3ff429a04daf4be024"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc912688caccd9172cb0c78584a6e193a4eaf778fe9464ad5f52b16ca659c085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fe05c375a095a82f08e2b2ef7a17bd737cf4a607734a7031ae9091610f13c93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36725d9fb1b9d620b99a0d698ed1bc2e1edf552860f56c9f3042db9780e5d9a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb32193ab52b23fe42ac961c278e46dd0217fd30b97ead0fec50a93f0cae8506"
    sha256 cellar: :any_skip_relocation, ventura:        "e5708b82a0eed74c153a33b83a055f07bd81811a54db520946b3ced498ae8ef1"
    sha256 cellar: :any_skip_relocation, monterey:       "348d41a41d79216906b80c7544a7139b345e044e77cb4024b696833a0fe0ddb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e053dc96b07fcef7f0f6a52fffc7ee35fc608e969496dc97326c38b01354f0"
  end

  depends_on "go" => :build
  depends_on "postgresql@16" => :test

  def install
    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    fork do
      exec bin/"doltgres"
    end
    sleep 5
    psql = "#{Formula["postgresql@16"].opt_bin}/psql -h 127.0.0.1 -U doltgres -c 'SELECT DATABASE()'"
    assert_match "doltgres", shell_output(psql)
  end
end
