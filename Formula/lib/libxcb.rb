class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.16.tar.xz"
  sha256 "4348566aa0fbf196db5e0a576321c65966189210cb51328ea2bb2be39c711d71"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf7a5932142b247a4af6b7681ac44b74e16081806e651640e3ae460df08d71a7"
    sha256 cellar: :any,                 arm64_monterey: "8a0df37f2087ac271ae9780b2db056b4a75f2090a535ac7c9560944d295962db"
    sha256 cellar: :any,                 arm64_big_sur:  "42b2a0a1eee03d44c137195a485153f4a185bac30f64c5fffe28576fc8bbc611"
    sha256 cellar: :any,                 ventura:        "9db0c9b29509ebae89d9592d3afe997f12949b3e96ea13661cf2080552aecf59"
    sha256 cellar: :any,                 monterey:       "668eb7405f2bc6e32007e3c4ee40adb88c1e26db47c3389aa8719bd4b5c7f8f1"
    sha256 cellar: :any,                 big_sur:        "ba2af806eddb9db3f65ab2c462d749fbadd03dd30d1ee6c5493ee466855dcae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37069aebf6799c5799d31ea9b6a25549726260b583cc6657bc858f4cd32c2f55"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # match version in `xcb-proto`
  depends_on "xcb-proto" => :build
  depends_on "libxau"
  depends_on "libxdmcp"

  def install
    python3 = "python3.11"

    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-dri3
      --enable-ge
      --enable-xevie
      --enable-xprint
      --enable-selinux
      --disable-silent-rules
      --enable-devel-docs=no
      --with-doxygen=no
      PYTHON=#{python3}
    ]

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include "xcb/xcb.h"

      int main() {
        xcb_connection_t *connection;
        xcb_atom_t *atoms;
        xcb_intern_atom_cookie_t *cookies;
        int count, i;
        char **names;
        char buf[100];

        count = 200;

        connection = xcb_connect(NULL, NULL);
        atoms = (xcb_atom_t *) malloc(count * sizeof(atoms));
        names = (char **) malloc(count * sizeof(char *));

        for (i = 0; i < count; ++i) {
          sprintf(buf, "NAME%d", i);
          names[i] = strdup(buf);
          memset(buf, 0, sizeof(buf));
        }

        cookies = (xcb_intern_atom_cookie_t *) malloc(count * sizeof(xcb_intern_atom_cookie_t));

        for(i = 0; i < count; ++i) {
          cookies[i] = xcb_intern_atom(connection, 0, strlen(names[i]), names[i]);
        }

        for(i = 0; i < count; ++i) {
          xcb_intern_atom_reply_t *r;
          r = xcb_intern_atom_reply(connection, cookies[i], 0);
          if(r)
            atoms[i] = r->atom;
          free(r);
        }

        free(atoms);
        free(cookies);
        xcb_disconnect(connection);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lxcb"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
