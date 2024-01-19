class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1560.tar.gz"
  sha256 "d720750e57e415e2e74aeea7eadb1aaa1372cc28c9adc0dfbe0169b816a1d66d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dc8f3fedd62ba2ce38077c881f5572adbe79914c8e7cd3a34ca9ca5fff55a215"
    sha256 cellar: :any,                 arm64_monterey: "c9246954176c31874cd031a1aa53b219c39ac81658a73a37e98d5d034bdb6147"
    sha256 cellar: :any,                 ventura:        "5ea45db32caa356d7f0e612c1b01e41de72a3082a40e43d7fcd2a015b94ea07b"
    sha256 cellar: :any,                 monterey:       "9c7ccc906986a05933fa3e7589c9ea8a31b06a04586d01b4a06dd487dddcb002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7002b40ad6a54d68dd825b1e496a871b05a4c0ae403519a98eaf274c873bb968"
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
