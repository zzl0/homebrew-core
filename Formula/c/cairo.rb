class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.18.0.tar.xz"
  sha256 "243a0736b978a33dee29f9cca7521733b78a65b5418206fef7bd1c3d4cf10b64"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://gitlab.freedesktop.org/cairo/cairo.git", branch: "master"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)cairo[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "84e7360cad90474ba243cdb3a523d384ca6ddbba2265615bc70454ccb90f8a01"
    sha256 arm64_ventura:  "4a0f5f55a3314f6b4223661c3af406d3551349b4dcabfda7a6e7b6a569187764"
    sha256 arm64_monterey: "50feaae83e93330cc0ee6b90477cfa931fab52cdb98ad37a99a0e518da6a580e"
    sha256 arm64_big_sur:  "2fc4da6029167f696fc0b3c0553d36abb8e77c75f0096396d4eb89d0ea912612"
    sha256 sonoma:         "c0b97dce5db0d0d3761c7a5dc3b4755392826e66215f749b4c92bb17f21b5a0c"
    sha256 ventura:        "6b0cbde9c14ef3995e0caba6c743bf8534ac5be9a32d5b74b7e47015f9e1baca"
    sha256 monterey:       "ccf4f80f5115aad260e4d3f014dc0aebdd616dfac88f567d211bd8681d60c3a9"
    sha256 big_sur:        "cb16c1bb070a7cdca7aaf8899a70e407d73636116d62225626b2c8d31aa8d2ff"
    sha256 catalina:       "4a117545953b9784f78db8261c03d71a1ae7af836dcd995abe7e6d710cdfd39c"
    sha256 mojave:         "38c7b7b0f6266632a5f04df12180dc36a1ce218a1c54b13cdca18ad024067311"
    sha256 x86_64_linux:   "678c795a11134b3455002969fc41b8e2512e97cdaa084f792724ace7549a3407"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "lzo"
  depends_on "pixman"

  uses_from_macos "zlib"

  def install
    args = %w[
      -Dfontconfig=enabled
      -Dfreetype=enabled
      -Dpng=enabled
      -Dglib=enabled
      -Dxcb=enabled
      -Dxlib=enabled
      -Dzlib=enabled
      -Dglib=enabled
    ]
    args << "-Dquartz=enabled" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cairo.h>

      int main(int argc, char *argv[]) {

        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);

        return 0;
      }
    EOS
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairo
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -L#{lib}
      -lcairo
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
