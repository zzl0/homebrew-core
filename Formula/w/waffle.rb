class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "https://waffle.freedesktop.org/"
  url "https://waffle.freedesktop.org/files/release/waffle-1.8.0/waffle-1.8.0.tar.xz"
  sha256 "29f462b5ea93510f585ae59b09f1aef6f9bad7287c7b82a7e8bd88f766e3afc7"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f885c9317964ed3b841645b75b5c929d98c5457ed0911c41a586d4e436913669"
    sha256 cellar: :any, arm64_ventura:  "721f578546fef947d5988c423d62edbf5ca4df91bf23132edd0a3dba96e415f3"
    sha256 cellar: :any, arm64_monterey: "bd5edd13379bac6277403de70afc6a513ab780f0aaf19ee40c0e56487a1fb7b4"
    sha256 cellar: :any, arm64_big_sur:  "3fdbf3b04577f26ecc7b15bb75ccb973157a3aea16e76b604627c215e4b79fa4"
    sha256 cellar: :any, sonoma:         "909e9fe5b65a4978db9744ca93f00a2656a0391071e08431479a37c53e57ea26"
    sha256 cellar: :any, ventura:        "88d13319655ba24a51c7de5342d3e01a90ec5e74abd415f2d5a6ac5f5d601ff6"
    sha256 cellar: :any, monterey:       "9675280d92c77e188cf93c766040a4f713a9e387817183c3cc646dd581a876a4"
    sha256 cellar: :any, big_sur:        "cfda02466d84027d572e6c524bda6041d9f3e401f5ff8a7994cdffdaca0be1d8"
    sha256               x86_64_linux:   "ef964770f31d2fdae40b23efc0b3b1c1fffdfa8430eb125adf9a9d8c805f0bb1"
  end

  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "libxcb"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    args = %w[
      -Dbuild-examples=true
      -Dbuild-htmldocs=true
      -Dbuild-manpages=true
    ]

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    cp_r prefix/"share/doc/waffle1/examples", testpath
    cd "examples"
    # Homebrew-specific work around for linker flag ordering problem in Ubuntu.
    unless OS.mac?
      inreplace "Makefile.example", "$(LDFLAGS) -o gl_basic gl_basic.c",
                "gl_basic.c $(LDFLAGS) -o gl_basic"
      inreplace "Makefile.example", "$(LDFLAGS) -o simple-x11-egl simple-x11-egl.c",
                "simple-x11-egl.c $(LDFLAGS) -o simple-x11-egl"
    end
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?
    system "make", "-f", "Makefile.example"
  end
end
