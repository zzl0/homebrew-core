class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c69d2c9c0d69970bdaffb33115384f7dd35843cd4169661b7b6430272a17f50a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0da15102629aec8f4bd5f27f091d8994761bd68f9113ab9229d92335d0fc94a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf81837cd60eee8578b0d00ed0fd9c68c7b80b28c0db224c6a1c61513697f44e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f8a8c3c4746a419d5b3e69bbf9ad40380351bfe8fd430f2ab0c7aead7f36ab"
    sha256 cellar: :any_skip_relocation, ventura:        "3bf8883deeb96db1b87e55be9ec1816e1ff01f27f546ecf703f12ca8eb3710d8"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb35862302177be55ec7e027d6a4618a2aeace88b32b1e415c690ff7656e0e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "48bc86d143652c4b56a37b05bcf5e9ed47fb7afac263bf36c9e5dbff1bf4e5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "268c71d8f15552373a82a39caa962fce0de5f88f9a93b8ea1933735f7d2fca70"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https://github.com/signalapp/libsignal/blob/#{libsignal-client.version}/rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # curl -fsSL https://github.com/AsamK/signal-cli/releases/download/v${version}/signal-cli-${version}-Linux.tar.gz |
  #   tar -tz |
  #   grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.30.0.tar.gz"
    sha256 "a9fe90f35c87c85d30efed3ffa0f717196e10eba4d2a9c95fa8129e88847f7f0"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#manual-build

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      res = r.resource
      odie "#{res.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != res.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni.so", "libsignal_jni.dylib", "signal_jni.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "shared/resources" do
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni")
        end
      end
    end
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}/signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", io.read
  end
end
