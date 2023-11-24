class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.12.1.tar.gz"
  sha256 "fa1845d42b46c6b5046a8f95d49cc7a9175e40efc5c13b95174b4c556567aca1"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bd1051ea2e2f68e688d78dedee988724cc2213d3748e943587263c424802f55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ad1779a54bc55060486c35159c842769f4a63812f07860eba226e61434c7c4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4682a1b96035333322516d3fbfff2ef0a03becc4539a9a97862b10b15cf7a080"
    sha256 cellar: :any_skip_relocation, sonoma:         "627e2c47d2799edaf06edba1acc378fb865ab6b6d314f4e04e2d52aee0ffa814"
    sha256 cellar: :any_skip_relocation, ventura:        "c7c1f9fa6aa92c8409a78d54667e2a3c82979c6e818ffec770078ca93feea507"
    sha256 cellar: :any_skip_relocation, monterey:       "d485ba328e481eaff9daa513efe59f21f4cd4ac696f95134e87768173ffb3d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9316b8f84f94bf0e397ce0555566eff112c231e79be2861159783437ea57e8"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202311230040/geoip.dat"
    sha256 "1719c271db87f88c3480baffa61b02e28440fc3561fa031482d5fd928d13ad61"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202311230040/geoip-only-cn-private.dat"
    sha256 "3102515134af15e30cd9c047081a63be760d435d3399c264e2d242c10e78dcaf"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20231122065640/dlc.dat"
    sha256 "469fdf0e2ff6dea1ec347dc639453f7007ce96fc594861fc9a443ef709970b01"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
