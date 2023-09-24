class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.887.tar.gz"
  sha256 "8248f4b47b37084680e9ec3e992a7614c40b1b322be26c20b9fa9316b7ab9f9a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01764a684ebc492e18bc1622fd9992f45b7ec8a273adfb2308e291fb5019eef7"
    sha256 cellar: :any,                 arm64_monterey: "4073affefe88b2c737187da5c71a43e9e71d0b92bd50127262217b82a34de5f0"
    sha256 cellar: :any,                 arm64_big_sur:  "3ea7a318ebeba83894f2e97d16ee951ea19442f53fb3b3aecf534b59f8d09777"
    sha256 cellar: :any,                 ventura:        "2860cdeb6bae16dfc1634dc3f0a9f0a9f49f33b257fe66211e5076eaaa2b8adc"
    sha256 cellar: :any,                 monterey:       "259dcb9e68445e055b9454335a812aae2156a1381c6ea79fb7a4b02d95d40a50"
    sha256 cellar: :any,                 big_sur:        "98b5526a13de810fecce2cabab95edf843db40425c7c0df4447070a83f659fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe24a9d94beee78248b4dd8807b9aa5b3c38e88520b260b043d0c8432780b3a"
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
