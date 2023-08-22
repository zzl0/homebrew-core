require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.8.tgz"
  sha256 "4b41f602fe7bbe772d7de51afa6ae725a94b7d4587b778ce16592e2c34abb3aa"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "6669df90da0d22937583867c3e5c369efaad401711db8d727dd892e7d513bfb8"
    sha256                               arm64_monterey: "941f062d55ceb286053edc78225affd2c719b7ff0c1b676d5e3fec2f6abdea15"
    sha256                               arm64_big_sur:  "7ea65aaf22dd019595e52b596572990f3fc2c613fe263a880e7797d968b53f55"
    sha256                               ventura:        "0ff4f06727a3eedd1b57e2821b3407d7e9bfe5a9ef600c5099a3c219fe10fdae"
    sha256                               monterey:       "bdd51b0f4f1bbd0259cdaf3af3a45031b6ad658def8f78937ad80782228291c8"
    sha256                               big_sur:        "506a66614028bb88450ebb14ef0c743943d199d81a1b5a1945647c43fd35c103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "507f65851496a4bef8895259d85e0f1f322ec34c392d309bcee86df9ad17d8f2"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
