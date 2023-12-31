class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.14.1.tar.gz"
  sha256 "03eef502cb3246f6863ec4590780e5c6b7d510a43fbb6e91d2c20103084b9613"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a3dca036adaaa98c8caa6ee6c07bdaa759c6186e2071d77248f0cba7d3252d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "623c407424a5eb290da34bd6feb00b021013c7a9b63c7e92ca14d8c6a51c2d96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4461b484109aa48b6c0b00fdf49ea896621ee2d0b3840043f8fd016001bf8dc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "02f9b35b6d4e34102b28f08b68fbeeee7000fb4a0eacc927a14c2ccc8b56bd1e"
    sha256 cellar: :any_skip_relocation, ventura:        "5a76d20973a9f888ba70ace96638f5ae50e6d3bfb3c115a688217addee4393d4"
    sha256 cellar: :any_skip_relocation, monterey:       "0e5f111a3c08725fbdb6c7ad2cbe595639af7d841112819e9cd7e4f725324afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d734061605ec831f381a7392b8bf4685bfed8f93fc8538e9819a55eb972037b8"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
