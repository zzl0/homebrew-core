class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.28.1/v2.28.1.tar.gz"
  sha256 "62b866cf2175f174eb2c878a3cec86479df0348f1058a49f2886b39ebcc46b45"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66ef05b4991b0f286c0992778aaded60aa5ae8fe4c9cb88727179806c1f48c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e1916c7b34ecf2fbf3f61cc24195c0b954361a02cb94e04a68a8af27dc66c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54f74da568cba5329c80f2913a9694f9ec07042d19db1374df3741fd4809003f"
    sha256 cellar: :any_skip_relocation, sonoma:         "22fe666905fb949cf0a29fa9e04f387e3390fb2bdd66e8fee99b17e7a63e5b72"
    sha256 cellar: :any_skip_relocation, ventura:        "63be61a04838d01f660441e0fa0533f7fed56264976288adb68bbfd241a0777e"
    sha256 cellar: :any_skip_relocation, monterey:       "a025d53c2ff3a043d2ed38fe6de0a3c387e111a505a1ac6a8057722771bc109c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e545e0a430d433f8ab36daac10cbc34e620ffa65a5ed9cc51e79985b8c892e55"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec/"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec/"spicetify"
    end
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file
    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~EOS
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    EOS
    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")
    assert_match "SpicetifyDefault", shell_output("#{bin}/spicetify config current_theme")
  end
end
