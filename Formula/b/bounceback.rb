class Bounceback < Formula
  desc "Stealth redirector for red team operation security"
  homepage "https://github.com/D00Movenok/BounceBack"
  url "https://github.com/D00Movenok/BounceBack/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "9f18c3b00f19f832a6ec9cfc4383d38a3ca400e470cc356c3cd41ea3d7919466"
  license "MIT"
  head "https://github.com/D00Movenok/BounceBack.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/bounceback"

    pkgshare.install "data"
    # update relative data path to homebrew pkg path
    inreplace "config.yml" do |s|
      s.gsub! " data", " #{pkgshare}/data"
    end
    etc.install "config.yml" => "bounceback.yml"
  end

  service do
    run [opt_bin/"bounceback", "--config", etc/"bounceback.yml"]
    keep_alive true
    working_dir var
    log_path var/"log/bounceback.log"
    error_log_path var/"log/bounceback.log"
  end

  test do
    fork do
      exec bin/"bounceback", "--config", etc/"bounceback.yml"
    end
    sleep 2
    assert_match "\"message\":\"Starting proxies\"", (testpath/"bounceback.log").read
    assert_match version.to_s, shell_output("#{bin}/bounceback --help", 2)
  end
end
