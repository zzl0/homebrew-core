class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1073.tar.gz"
  sha256 "c4385b00add96950c98b06c4e27466e1d6f1e5cb9aa0b17464bf94774043567c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b4bedb2aec47966f528346e1416fcabacf351e3be625deab78e7fa2d090b225"
    sha256 cellar: :any,                 arm64_monterey: "2729461e2b40cacfb0d8e1066cab9ba16b72f914935afb73a9654a090bd80956"
    sha256 cellar: :any,                 ventura:        "7be8dc8ee8f4a9e7b7907c07c2d630f2b23746bb51f7815f7c76d057fca9e2f3"
    sha256 cellar: :any,                 monterey:       "d74c86c9f5aafd86cca150e7ed8db2b909add20c32b8a06c7b07ed9ec939b512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c647ee81ed93a3d4f9a43cbf617cf56508ae6a0200d0461d01ad37d85f2009b9"
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
