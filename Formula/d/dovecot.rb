class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.21.tar.gz"
  sha256 "05b11093a71c237c2ef309ad587510721cc93bbee6828251549fc1586c36502d"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://www.dovecot.org/download/"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "c9e2fc781d0b0a896294e5619d85d19c0d01d0d4e5a833e6b380ba792dc2fa2c"
    sha256 arm64_monterey: "b911df521e2e6961d5db4553b92e009aa9cce6f84d3fb7a5d5fda0115e3c8355"
    sha256 arm64_big_sur:  "4c0cacdc42c3170b298fc0a88f5085a51a51ee052b04956fe2d1067b630a0819"
    sha256 ventura:        "81a94d994329d3a3c8b2ff8f1774a280ae54330174bd1dfad2826fec54287a7b"
    sha256 monterey:       "b323934b7d27693e28a8d0047576dff6f8029d721e0d6d5d97d6b1afeca30a4a"
    sha256 big_sur:        "0c9fbdb439b3e781d23ecc4a4f65c81f11ad6a3d238d217eae5918916658bf61"
    sha256 x86_64_linux:   "8a23a5a515f5f09cc8bbfc9302cc4e0d9cb23ed3368a5eb0241edaded1882759"
  end

  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "linux-pam"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.21.tar.gz"
    sha256 "1ca71d2659076712058a72030288f150b2b076b0306453471c5261498d3ded27"
  end

  # dbox-storage.c:296:32: error: no member named 'st_atim' in 'struct stat'
  # dbox-storage.c:297:24: error: no member named 'st_ctim' in 'struct stat'
  # Following two patches submitted upstream at https://github.com/dovecot/core/pull/211
  patch do
    url "https://github.com/dovecot/core/commit/6b2eb995da62b8eca9d8f713bd5858d3d9be8062.patch?full_index=1"
    sha256 "3e3f74b95f95a1587a804e9484467b1ed77396376b0a18be548e91e1b904ae1b"
  end

  patch do
    url "https://github.com/dovecot/core/commit/eca7b6b9984dd1cb5fcd28f7ebccaa5301aead1e.patch?full_index=1"
    sha256 "cedfeadd1cd43df3eebfcf3f465314fad4f6785c33000cbbd1349e3e0eb8c0ee"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-pam
      --with-sqlite
      --with-ssl=openssl
      --with-zlib
      --without-icu
    ]

    system "./configure", *args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --disable-dependency-tracking
        --with-dovecot=#{lib}/dovecot
        --prefix=#{prefix}
      ]

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  service do
    run [opt_sbin/"dovecot", "-F"]
    require_root true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/dovecot/dovecot.log"
    log_path var/"log/dovecot/dovecot.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")

    cp_r share/"doc/dovecot/example-config", testpath/"example"
    inreplace testpath/"example/conf.d/10-master.conf" do |s|
      s.gsub! "#default_login_user = dovenull", "default_login_user = #{ENV["USER"]}"
      s.gsub! "#default_internal_user = dovecot", "default_internal_user = #{ENV["USER"]}"
    end
    system bin/"doveconf", "-c", testpath/"example/dovecot.conf"
  end
end
