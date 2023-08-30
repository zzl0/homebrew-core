class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/1.9.5/fwupd-1.9.5.tar.xz"
  sha256 "201ec20538044749c96dbff708e52f7d79038de787b90a2762e76793080aa37c"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-markupsafe" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libcbor"
  depends_on "libgusb"
  depends_on "libjcat"
  depends_on "libxmlb"
  depends_on "protobuf-c"
  uses_from_macos "curl"
  uses_from_macos "libarchive"
  uses_from_macos "sqlite"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  def python3
    "python3.11"
  end

  def install
    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, python3)
    venv.pip_install resources

    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dpython=#{venv_root}/bin/python",
                    "-Dsupported_build=enabled",
                    "-Dplugin_dell=disabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_gpio=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_msr=disabled",
                    "-Dplugin_tpm=disabled",
                    "-Dplugin_uefi_capsule=disabled",
                    "-Dplugin_uefi_pk=disabled",
                    # these two are needed for https://github.com/fwupd/fwupd/pull/6147
                    "-Dplugin_logitech_scribe=disabled",
                    "-Dplugin_logitech_tap=disabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath/"test.c").write <<~EOS
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/fwupd-1
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lfwupd
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system "#{bin}/fwupdtool", "-h"
  end
end
