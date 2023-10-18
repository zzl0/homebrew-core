class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.2.2.tar.gz"
  sha256 "ca999be08800edc6d265379c4c7aafad92f0ee400692e4e2d69829ab4b4c3d08"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "53943e914be8be83327314d5e23a550f4b6ee31cb4ebebe85e27aa1bce80968a"
    sha256 cellar: :any,                 arm64_ventura:  "cd7dc0b092e95bf3fdcf6f6d6a26a68c4bafcf6018220c121c7cd0fc3f5d5465"
    sha256 cellar: :any,                 arm64_monterey: "a151d72c6dc3d502a0f53640e8ef89bf5401ba3c444b0da5a6f52a93ff418192"
    sha256 cellar: :any,                 sonoma:         "648d64daed3802f6510ec1849704f85f8272eaa346a01a1bb2144306b0c438a5"
    sha256 cellar: :any,                 ventura:        "1568685e4500ef9cae5c998763f13c51c4d87beead4c61b21e266f729439b5ed"
    sha256 cellar: :any,                 monterey:       "6cdc1f0ec9d5efa53d1a8820e5deafed6a5e87e967785045a5c4240bca203063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ee5e17a10fc95eef2b90c07668fa70a155081d0387d023b9f988abdb906601"
  end

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
