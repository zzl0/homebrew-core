class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.16.tar.gz"
  sha256 "1d44ebc853345c5153602d9a88511e795ed53ec5e89fb09038a3f8c76e2c6f93"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This only returns versions
  # from releases with "Mainnet" in the title (e.g. "Mainnet - v1.2.3").
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["name"]&.downcase&.include?("mainnet")

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fcfb1256c7f00c73a686e259e53e682da430995faee340a7ae7645d54492680"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac1ed72b64d98dcf0ba45d74917631909e3e24f7912832d01d7f1d3c7e3520ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112f1f82339bd04cdfe0aaf46c46296fd5da02b485385ae749ab4e15a244fb4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d66d53f7a12ba792052cf6757c4f2a95d443e029b6a4f44a2b290e7c1e2b1567"
    sha256 cellar: :any_skip_relocation, ventura:        "9d4f2ccf124e829a99ac452ba068471b2d8b23526626ebd20e9a52065edced7b"
    sha256 cellar: :any_skip_relocation, monterey:       "9a03cc116feea7324e0ea0bb7d16ba6a1fa599b547b3e51deebf9fabf9df92df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635ca7a98c27a98d8bde7235f0b7328e0c46e09068561ec64cc6e1cfe5c80202"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd"
  end

  def install
    %w[
      cli
      bench-streamer
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      tokens
      watchtower
    ].each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
