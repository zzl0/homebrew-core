class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.635.tar.gz"
  sha256 "fc6f20aead6e1759d760bb45b45829396c3472cafffaca6cabde7012d477825d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "05c6eff99cc2a309e5a3bf6a076f45fb595720fe405c22894d928c21e51c5a09"
    sha256 cellar: :any,                 arm64_monterey: "5644f1aa35436fc4391888b967a84b256ee981a2c3fd2cdb8dd1b584b2ea7e1c"
    sha256 cellar: :any,                 arm64_big_sur:  "053b8da525714171eb5be20ca1d9bbfccafd59587df0d87b4984facae3c1a3f6"
    sha256 cellar: :any,                 ventura:        "f3e03224278b74e1fa09b7048263f09613f25d757ceba1930eb9d86876d7743c"
    sha256 cellar: :any,                 monterey:       "20c86796f6da5c471fdc43b57e3b10740debe963c32f01e5122119d98c03338c"
    sha256 cellar: :any,                 big_sur:        "d3bfb0fa45b821ccd13586d9cf3743b047fafbcebcd8ca658dc52aa9f70c67cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13fc66c8319dd5dc0bc4054e2e0ab7dbac2955204346d1ec4d9330f4d7fa890e"
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
