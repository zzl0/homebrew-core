class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.75.0-src.tar.gz"
    sha256 "5b739f45bc9d341e2d1c570d65d2375591e22c2d23ef5b8a37711a0386abc088"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.76.0.tar.gz"
      sha256 "52d57889715cdfe0070b13f6d4dbfc4affdafc763483269e78b6ebd7166fdb83"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "be46d15d3fbef5ae61104a8ce81e9a8f2719563f060fc84df5348081707f6d40"
    sha256 cellar: :any,                 arm64_ventura:  "499c4effbd4234b1819ecd4cc60c11e1f6f907727df47914c3f1f2be52eab01f"
    sha256 cellar: :any,                 arm64_monterey: "c617de08e813aaccabc42d4e72baa7fc701a7e91716ded6f6f7a2e526ef5611f"
    sha256 cellar: :any,                 sonoma:         "948d49f447a47930260fc01d8f305aae3152f55d764d3452027a624258c18f1e"
    sha256 cellar: :any,                 ventura:        "980242b3fb8cd42d7fff3716ca0d71ca77aac742c2fb0e0a1bbd71c75c45e38c"
    sha256 cellar: :any,                 monterey:       "c5bad0c271901607e341fac2f5c58d92293d710036a4d264ba290c01ea108742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a78550a978b777daf1a786d9a7d91692c1b9ccdabde32eb96e4dc5481429926a"
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
        url "https://static.rust-lang.org/dist/2023-11-16/cargo-1.74.0-aarch64-apple-darwin.tar.xz"
        sha256 "5c14e9b3a458d728d89e02f4e024b710d5b0eb8c45249066fe666d2094fbf233"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-11-16/cargo-1.74.0-x86_64-apple-darwin.tar.xz"
        sha256 "5c1c4f5985a48ad02bcff881c5a9c983218bc1eefc083403579147a3292ba073"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-11-16/cargo-1.74.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "c5ad01692bc08ce6f4db2ac815be63498b45013380c71f22b3d33bf3be767270"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-11-16/cargo-1.74.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "f219386d4569c40b660518e99267afff428c13bf980bda7a614c8d4038d013f6"
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
      rust-analyzer-proc-macro-srv
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
      --enable-profiler
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
diff --git a/src/bootstrap/src/core/build_steps/compile.rs b/src/bootstrap/src/core/build_steps/compile.rs
index 7021a95..af69860 100644
--- a/src/bootstrap/src/core/build_steps/compile.rs
+++ b/src/bootstrap/src/core/build_steps/compile.rs
@@ -592,7 +592,9 @@ impl Step for StdLink {
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
