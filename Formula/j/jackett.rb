class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.784.tar.gz"
  sha256 "3a2cccd71bc16202c7067cf5332a662e4b924c5a8489386a694f28ae9a444d71"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "325ace99724e75f9ca0d3a8f3595b8b71e612abf2af1a8a1d78a94c2d02aff50"
    sha256 cellar: :any,                 arm64_monterey: "52178ff076dfb7efcccfd0c3456f914bfecd6fd8c4fed318c2ec6644ae181727"
    sha256 cellar: :any,                 arm64_big_sur:  "0f961c9d4aef670d6f72235368a9185c0bb3d032d4020d89658c12ac509ddb17"
    sha256 cellar: :any,                 ventura:        "b36f80d0582ee07f9a46167478a26697ada3e47068aefc2dd3ef409dea06055c"
    sha256 cellar: :any,                 monterey:       "295f414d6dce2ecf5ceac1a65aa6bac2d46bbdc177bce042f7b0fc87dfc74fc9"
    sha256 cellar: :any,                 big_sur:        "f8fdf0d0dec988c06169945108e2767f93efafd03cc58a789623f5641fedab35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f239481b4aebbb8be7662c238fc93d2391622ecc8a93bf6767d968c977e56e5e"
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
