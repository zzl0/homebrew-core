class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "ace861d8bab91b1e5d1943f86a1e1e29cdc1eca6ef509f1f983964a7c80f90be"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f0a80658c79ae703a2a4b7bb84b8b46284276cd89762e8ebdb9e907060b46d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42d50e3f08045f2ee061d69883df385a5cc8dd876ff73c6f24fc81fd02e14091"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6562a1ff8a4aeea01e664083386731a9ac9834f7b288b22e7e8e841c8fd16504"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bcced8f0b09f74ae231dec74847489e6cc76f224db347183c634a964b26a797"
    sha256 cellar: :any_skip_relocation, ventura:        "7e61bc46a45c6eac9b852f2156214ee6b02d8393adc7892d2126de16b3d90789"
    sha256 cellar: :any_skip_relocation, monterey:       "cdbde05e69c2c184b3d0c0e74175e58a81f2ef8314a009515b66d47b1770f72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c44fa8c8293f0b3f5ae2a3caef36cabfe042a392699d978393aad97ce7990b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@3"
  end

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = opt_bin
    ENV["FFPWA_SYSDATA"] = opt_share
    system "bash", "./packages/brew/configure.sh", version.to_s, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin/"firefoxpwa-connector"
    share.install "manifests/brew.json" => "firefoxpwa.json"
    share.install "userchrome/"
    bash_completion.install "target/release/completions/firefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "target/release/completions/firefoxpwa.fish"
    zsh_completion.install "target/release/completions/_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "/Library/Application Support/Mozilla/NativeMessagingHosts"

    on_linux do
      destination = "/usr/lib/mozilla/native-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}/#{filename}" "#{destination}/#{filename}"
    EOS
  end

  test do
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
