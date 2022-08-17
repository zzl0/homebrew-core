class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git", branch: "master"

  stable do
    url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-16.1.tar.xz"
    sha256 "8eef32ce91d47979f95fd9a935e738cd7eb7463430dabc72863251751e504ae4"

    # Backport fix for macOS build. Remove in the next release
    patch do
      url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/commit/baa3d24b760fe48d25d379b972728ea3ffa5492d.diff"
      sha256 "af1862ed1196719ae404be9bfde4ea2d74fb512b50fd5a37445de43be00c30c1"
    end
    patch do
      url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/commit/47a6918739cb06dafa970d0b528bed1951d95039.diff"
      sha256 "03264a384ccc84a1c61e206ddb136cc9a6ae67e88172b08e5b4378aca74f06a5"
    end
  end

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "27d4abbe8ff504b140b588fe78d7e7b798c0a076f94d1c25418b6a3be8fcd5e2"
    sha256 arm64_ventura:  "18a8f6d639cdd2e3e387886eada41d7fcb458d9bf03375a39fe7d372d60a92cf"
    sha256 arm64_monterey: "99b50d18d374013340228f611af63fcb66bdc9e0a681fa3a9ebb2c3b05a89430"
    sha256 sonoma:         "252b453dab9684b191f8119c2992f70b8e3cab3cd9b65e248b5f01e3b3a40649"
    sha256 ventura:        "cc5870768b17130fb40b517d422ef6e0b915695c2fac9a8e8931800caaab29d6"
    sha256 monterey:       "6febd7d96e526e962947e64c597701d0be1000a9f626b4a02467f0bf582f83d6"
    sha256 x86_64_linux:   "618016935992f4317a6cea21054682693644743dead13896e97af76ab93847b8"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@3"
  depends_on "orc"
  depends_on "speexdsp"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext" # for libintl
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libcap"
  end

  def install
    enabled_on_linux = if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      "enabled"
    else
      # Restore coreaudio module as default on macOS
      inreplace "meson.build", "cdata.set('HAVE_COREAUDIO', 0)", "cdata.set('HAVE_COREAUDIO', 1)"
      "disabled"
    end

    # Default `tdb` database isn't available in Homebrew
    args = %W[
      -Ddatabase=simple
      -Ddoxygen=false
      -Dman=true
      -Dtests=false
      -Dstream-restore-clear-old-devices=true

      -Dlocalstatedir=#{var}
      -Dbashcompletiondir=#{bash_completion}
      -Dzshcompletiondir=#{zsh_completion}
      -Dudevrulesdir=#{lib}/udev/rules.d

      -Dalsa=#{enabled_on_linux}
      -Ddbus=#{enabled_on_linux}
      -Dglib=enabled
      -Dgtk=disabled
      -Dopenssl=enabled
      -Dorc=enabled
      -Dsoxr=enabled
      -Dspeex=enabled
      -Dsystemd=disabled
      -Dx11=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  service do
    run [opt_bin/"pulseaudio", "--exit-idle-time=-1", "--verbose"]
    keep_alive true
    log_path var/"log/pulseaudio.log"
    error_log_path var/"log/pulseaudio.log"
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
