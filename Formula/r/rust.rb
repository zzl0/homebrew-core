class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.74.0-src.tar.gz"
    sha256 "882b584bc321c5dcfe77cdaa69f277906b936255ef7808fcd5c7492925cf1049"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.75.0.tar.gz"
      sha256 "d6b9512bca4b4d692a242188bfe83e1b696c44903007b7b48a56b287d01c063b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40687edb42b50bdf778643803a21a98fca07d86b6a138edfdd73a282c1e18ad8"
    sha256 cellar: :any,                 arm64_ventura:  "be9922a4b56016f18d209067f5a4d148d2aad4db3061092f848744aff41e337d"
    sha256 cellar: :any,                 arm64_monterey: "a9ada0e355a336a55545a16e615daa051c5a675dc05c63793a77b8bac98ba04e"
    sha256 cellar: :any,                 arm64_big_sur:  "9bfc9baf003134053944ad145cc48155a23607ff73fecd6d45d1e4d3b429d6fd"
    sha256 cellar: :any,                 sonoma:         "fbc3c8c3894f64dc121541cc9a50fb22a38ccff82d4dba9c370d70a6785f614e"
    sha256 cellar: :any,                 ventura:        "4cd3be4492eae97232dd1d868fb40f849882724688c4bd792f1e720d8710803d"
    sha256 cellar: :any,                 monterey:       "f7b8d6dc15d845f4ad715706542237386f97cf045e9168b34876bccb060e0e26"
    sha256 cellar: :any,                 big_sur:        "20214e26fbc77ef51e3be59c970ed9a109f3c13cfa7331a973d60d06b907760a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b6bb23066fccd7b3c9311d5c671768133bbe5c27cce132376c4c0ec30abf9c"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-10-05/cargo-1.73.0-aarch64-apple-darwin.tar.xz"
        sha256 "caa855d28ade0ecb70567d886048d392b3b90f15a7751f9733d4c189ce67bb71"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-10-05/cargo-1.73.0-x86_64-apple-darwin.tar.xz"
        sha256 "94f9eb5836fe59a3ef1d1d4c99623d602b0cec48964c5676453be4205df3b28a"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-10-05/cargo-1.73.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "1195a1d37280802574d729cf00e0dadc63a7c9312a9ae3ef2cf99645f7be0a77"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-10-05/cargo-1.73.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "7c3ce5738d570eaea97dd3d213ea73c8beda4f0c61e7486f95e497b7b10c4e2d"
      end
    end
  end

  # Fixes 'could not read dir ".../codegen-backends"' on 12-arm64.
  # See https://github.com/Homebrew/homebrew-core/pull/154526#issuecomment-1814795860
  patch :DATA

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    cargo_src_path = buildpath/"src/tools/cargo"
    cargo_src_path.rmtree
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    # rustfmt and rust-analyzer are available in their own formulae.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{Formula["llvm"].opt_prefix}
      --enable-llvm-link-shared
      --enable-vendor
      --disable-cargo-native-static
      --set=rust.jemalloc
      --release-description=#{tap.user}
    ]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"rustlib/src/rust").install "library"
    rm_f [
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ]
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }

    # We only check the tools' linkage here. No need to check rustc.
    expected_linkage = {
      bin/"cargo" => [
        Formula["libgit2"].opt_lib/shared_library("libgit2"),
        Formula["libssh2"].opt_lib/shared_library("libssh2"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
      ],
    }
    unless OS.mac?
      expected_linkage[bin/"cargo"] += [
        Formula["curl"].opt_lib/shared_library("libcurl"),
        Formula["zlib"].opt_lib/shared_library("libz"),
      ]
    end
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if check_binary_linkage(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end

__END__
diff --git a/src/bootstrap/compile.rs b/src/bootstrap/compile.rs
index 292ccc5780f..7266badf501 100644
--- a/src/bootstrap/compile.rs
+++ b/src/bootstrap/compile.rs
@@ -546,7 +546,9 @@ fn run(self, builder: &Builder<'_>) {
                 .join("stage0/lib/rustlib")
                 .join(&host)
                 .join("codegen-backends");
-            builder.cp_r(&stage0_codegen_backends, &sysroot_codegen_backends);
+            if stage0_codegen_backends.exists() {
+                builder.cp_r(&stage0_codegen_backends, &sysroot_codegen_backends);
+            }
         }
     }
 }
