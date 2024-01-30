class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1645.tar.gz"
  sha256 "836118e4dffa94a5dd2d22a75df82a041e53f6f4cc5b38bb9693756700ade69e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa73e90c88ac214cd5dd937d0890475f9b1c7056fe50f18ef170094ab81202af"
    sha256 cellar: :any,                 arm64_monterey: "bc160d787fc580e91b720177e01745a9ac984f696c0a462946cec41f0d464a66"
    sha256 cellar: :any,                 ventura:        "a89f13fb7262a8b3c5da9e9c0cb63ac685c815b26f86bc3a3b560d9769c37fe3"
    sha256 cellar: :any,                 monterey:       "2b5a9d88a3a777529beeca1b2569e03330af05b9ff17f44dccd2a8706535f213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba192eb5fb85374a64de3e56b6b46f6fc22e2f4123f78523d4e6a640ef91677"
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
