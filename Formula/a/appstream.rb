class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e964fea8b4b7efac7976dc13da856421ddec4299acb5012a7c059f03eabcbeae"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "13958c6501fe66eae4db052bc4b1cafdace94582dfce971246a2576f0eecdb39"
    sha256 arm64_ventura:  "e22556e5fba8e18bddde908ca3cb87fa32b1bf27a87ce636e7d64eb9c976cdbd"
    sha256 arm64_monterey: "c96f102ea8b12a4d41028ceb82792c1e22869583a038c950e0e0390d81815343"
    sha256 sonoma:         "d35f7905d588c035bd4d90075c843a409ab59934e678d6900aa580a3b18918c0"
    sha256 ventura:        "a0bc82b0bf8a07097069d9c3c67b59378624b693ef6cf5ebfd259e83c543bfa7"
    sha256 monterey:       "13c2bf0823221c19bd96ca07adcf30fb7b69bb3f30ad1f25ef2b864011fee113"
    sha256 x86_64_linux:   "b51dce98eeb7f1b48288d677ecaa2c9adaabc2ad16bde8281bc661a64c87b757"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "libxmlb"
  depends_on "libyaml"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "gettext" => :build
    depends_on "gperf" => :build
    depends_on "systemd"
  end

  # fix macos build, upstream PR ref, https://github.com/ximion/appstream/pull/556
  patch do
    url "https://github.com/ximion/appstream/commit/06eeffe7eba5c4e82a1dd548e100c6fe4f71b413.patch?full_index=1"
    sha256 "d0ad5853d451eb073fc64bd3e9e58e81182f4142220e0f413794752cda235d28"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    inreplace "meson.build", "/usr/include", prefix.to_s

    args = %w[
      -Dstemming=false
      -Dvapi=true
      -Dgir=true
      -Ddocs=false
      -Dapidocs=false
      -Dinstall-docs=false
    ]

    args << "-Dsystemd=false" if OS.mac?
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"appdata.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <component type="desktop-application">
        <id>org.test.test-app</id>
        <name>Test App</name>
      </component>
    EOS
    (testpath/"test.c").write <<~EOS
      #include "appstream.h"

      int main(int argc, char *argv[]) {
        GFile *appdata_file;
        char *appdata_uri;
        AsMetadata *metadata;
        GError *error = NULL;
        char *resource_path = "#{testpath}/appdata.xml";
        appdata_file = g_file_new_for_path (resource_path);
        metadata = as_metadata_new ();
        if (!as_metadata_parse_file (metadata, appdata_file, AS_FORMAT_KIND_UNKNOWN, &error)) {
          g_error ("Could not parse metadata file: %s", error->message);
          g_clear_error (&error);
        }
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs appstream").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/appstreamcli --version")
  end
end
