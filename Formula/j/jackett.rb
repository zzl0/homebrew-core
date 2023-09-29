class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.932.tar.gz"
  sha256 "1a566187973060553b777a35e5293fb63cd743d406884cef3d300d400417b45d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5cff4229a5b44719e95c3a2df00be516dd6c3ace29aa28939a30eae5f0a9efe1"
    sha256 cellar: :any,                 arm64_monterey: "262166f391090fe291db1ec8624bcd1864bd3c539037a32edb705c9168cdb4b5"
    sha256 cellar: :any,                 ventura:        "888d12b50cdca5e4976910a9e894009cc61923a9b85b4544213323baacce1843"
    sha256 cellar: :any,                 monterey:       "06a5cd78242fd3af186b79c96ca9ee1641995b734baee8324358889cf4eda8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0cddf9d5a0f68c079abf8a8b8a3af844d64c3bf462fa6503b7ff560c503407"
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
