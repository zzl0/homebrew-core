class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v3.0.0.tar.gz"
  sha256 "81088d5fb7dc6be1ab1c27bdd97230834e7daf0c901d1fde114bfe378989066a"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "039347dffd8633a967c6622f74c792555852ec59ff262ffcf8f91cc9a7497294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8207c8c31949eef4934e034f91597d0d57f472287742b628df28041cb84db37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "647794535369587e1add3ffe5d7eab51f6ed9d1d02d1ee37dac186d39b23da36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc9ed876f891ed70af869706a24f82cdc9a3f941001eaeaee243831b7920d2b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "56208e0813c2a659d01556c63afc635dbd52cb77edf024662e06cf4aff0d1c7b"
    sha256 cellar: :any_skip_relocation, ventura:        "a434e5b04efbb41f20bf86883a81331cb78c101718a3b73cea51f4d0b02a4b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "d4cf5c899f217816579ee43faf37eda9c51e616651c4acdfbe91dbc24f8e4920"
    sha256 cellar: :any_skip_relocation, big_sur:        "53d6a7d1d99665eda0c38d32a6e0e40d694799d831d8457fd25861898c143127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f39b21f33988175693515f4ab37e77bfe0f5ff7322b2e5812e5660f0d91a4a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
