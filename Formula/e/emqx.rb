class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump:
  #   https://github.com/emqx/emqx/blob/v#{version}/scripts/ensure-rebar3.sh#L9
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "4f817fa1e17606262165afe3a806de56b3d2a423deb13c2cc5c8160f7bcc4c75"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d1eeb902515982a2129af648c2722d42bea2b8169479fc74ebdcbc88a0073a8"
    sha256 cellar: :any,                 arm64_ventura:  "31dd0ba1e2e5ee81f9f049d05d8e04f553d474ff0af0f60309a2a758c9dcb78e"
    sha256 cellar: :any,                 arm64_monterey: "7e2b54f39d300ee636cbf0f763df030339acd9bb2f97789428e657d13cd93403"
    sha256 cellar: :any,                 sonoma:         "ffe06c1d4a4992f6068b513d57ade47ea4228b6254939f3482f1f7c76be27135"
    sha256 cellar: :any,                 ventura:        "f8344c186e540f50735a469fc90c6df2c362cc6e4fbde9a97d77f5b2a81ae8ac"
    sha256 cellar: :any,                 monterey:       "5515e9ff855ff122c583d4598c731a696b21deb0302c0dd87feabc0208631d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "030006f22e19ec7c8c7d15645256e14a21db331ccd9f78982371daef92b7bc50"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@25" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

  uses_from_macos "curl"  => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "zip"   => :build

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    ENV["PKG_VSN"] = version.to_s
    ENV["BUILD_WITHOUT_QUIC"] = "1"
    touch(".prepare")
    system "make", "emqx-rel"
    prefix.install Dir["_build/emqx/rel/emqx/*"]
    %w[emqx.cmd emqx_ctl.cmd no_dot_erlang.boot].each do |f|
      rm bin/f
    end
    chmod "+x", prefix/"releases/#{version}/no_dot_erlang.boot"
    bin.install_symlink prefix/"releases/#{version}/no_dot_erlang.boot"
    return unless OS.mac?

    # ensure load path for libcrypto is correct
    crypto_vsn = Utils.safe_popen_read("erl", "-noshell", "-eval",
                                       'io:format("~s", [crypto:version()]), halt().').strip
    libcrypto = Formula["openssl@3"].opt_lib/shared_library("libcrypto", "3")
    %w[crypto.so otp_test_engine.so].each do |f|
      dynlib = lib/"crypto-#{crypto_vsn}/priv/lib"/f
      old_libcrypto = dynlib.dynamically_linked_libraries(resolve_variable_references: false)
                            .find { |d| d.end_with?(libcrypto.basename) }
      next if old_libcrypto.nil?

      dynlib.ensure_writable do
        dynlib.change_install_name(old_libcrypto, libcrypto.to_s)
        MachO.codesign!(dynlib) if Hardware::CPU.arm?
      end
    end
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx", "ctl", "status"
    system bin/"emqx", "stop"
  end
end
