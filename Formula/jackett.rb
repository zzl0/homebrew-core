class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.574.tar.gz"
  sha256 "341156c70c1ba835d1802ff84bc23ce290d3a535db9e72d122973bb8b382f8a8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8398e0feb3fbebaddbe7ddf30eb584aebcd67a624775010268ca514c6d86042d"
    sha256 cellar: :any,                 arm64_monterey: "5535b469c2129ee2860c1080bf614c992531b0b90c8ca6b7ebfa50a1d731e2cc"
    sha256 cellar: :any,                 arm64_big_sur:  "5e4a5e6f102c081a4f6f192febeb8fe27a454ebfd113c1cf3f9aabfc0eed8047"
    sha256 cellar: :any,                 ventura:        "7af85dc747724d5c1ce8abbb16f9c25a8c3f45ba01d253b2432116fa1f7fcf2e"
    sha256 cellar: :any,                 monterey:       "4ddb43e77b62399a7c9120bd1a1b83dc8d7acc090ad2c3ce752d26d756675fc8"
    sha256 cellar: :any,                 big_sur:        "1f8149a5cc2138d41c960ce8cccdaaa9ce116d3968c732dd8525b1fb51f03a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5920d32a7ac90455c3ff30a33236b5012ab6ecc3687fae68e1988cb7513e1a"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
