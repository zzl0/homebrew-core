class Bozohttpd < Formula
  desc "Small and secure http version 1.1 server"
  homepage "http://www.eterna.com.au/bozohttpd/"
  url "http://www.eterna.com.au/bozohttpd/bozohttpd-20220517.tar.bz2"
  sha256 "9bfd0942a0876e5529b0d962ddbcf50473bcf84cf5e4447043e4a0f4ea65597a"
  license "BSD-2-Clause"

  depends_on "pkg-config" => :build
  depends_on "lua"
  depends_on "openssl@3"

  def install
    # Both `cflags` are explained at http://www.eterna.com.au/bozohttpd/bozohttpd.8.html
    cflags = [
      # Disable NetBSD blocklistd supprt, which is enabled by default (see section "BLOCKLIST SUPPORT")
      "-DNO_BLOCKLIST_SUPPORT",
      # Enable basic authentication, which is disabled by default (see section "HTTP BASIC AUTHORIZATION")
      "-DDO_HTPASSWD",
    ]
    cflags << Utils.safe_popen_read("pkg-config", "--libs", "--cflags", "lua").chomp
    cflags << Utils.safe_popen_read("pkg-config", "--libs", "--cflags", "libcrypto").chomp

    ENV.append "CFLAGS", cflags.join(" ")
    system "make", "-f", "Makefile.boot", "CC=#{ENV.cc}"
    bin.install "bozohttpd"
  end

  test do
    port = free_port

    expected_output = "Hello from bozotic httpd!"
    (testpath/"index.html").write expected_output

    fork do
      exec bin/"bozohttpd", "-b", "-f", "-I", port.to_s, testpath
    end
    sleep 3

    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
  end
end
