class Build2 < Formula
  desc "C/C++ Build Toolchain"
  homepage "https://build2.org"
  url "https://download.build2.org/0.16.0/build2-toolchain-0.16.0.tar.xz"
  sha256 "23793f682a17b1d95c80bbd849244735ed59a3e27361529aa4865d2776ff8adc"
  license "MIT"

  livecheck do
    url "https://download.build2.org/toolchain.sha256"
    regex(/^# (\d+\.\d+\.\d+)(?:\+\d+)?$/i)
  end

  depends_on "pkgconf"

  uses_from_macos "curl"
  uses_from_macos "openssl"
  uses_from_macos "sqlite"

  def install
    pkgconf = Formula["pkgconf"]
    sqlite = Formula["sqlite"] if OS.linux?

    # Suppress loading of default options files.
    ENV["BUILD2_DEF_OPT"] = "0"

    # Note that we disable all warnings since we cannot do anything more
    # granular during bootstrap stage 1.
    chdir "build2" do
      system "make", "-f", "./bootstrap.gmake", "CXXFLAGS=-w"
    end

    chdir "build2" do
      system "build2/b-boot", "-v",
             "-j", ENV.make_jobs,
             "config.cxx=#{ENV.cxx}",
             "config.bin.lib=static",
             "config.build2.libpkgconf=true",
             "config.cc.poptions=-I#{pkgconf.include}/pkgconf",
             "config.cc.loptions=-L#{pkgconf.lib}",
             "build2/exe{b}"
      mv "build2/b", "build2/b-boot"
    end

    loptions = "-L#{pkgconf.lib}"
    loptions += " -L#{sqlite.lib}" if OS.linux?

    # Work around macOS dylib cache in /usr/lib (can be dropped after 0.17.0).
    if OS.mac?
      mkdir "#{buildpath}/build/lib"
      ln_s "#{MacOS.sdk_path}/usr/lib/libsqlite3.tbd", "#{buildpath}/build/lib/libsqlite3.dylib"
      loptions += " -L#{buildpath}/build/lib"
    end

    # Note that while Homebrew's clang wrapper will strip any optimization
    # options, we still want to pass them since they will also be included
    # into the ~host and ~build2 configurations that will be used to build
    # built-time dependencies and build system modules, respectively, when
    # the user uses actual clang.
    system "build2/build2/b-boot", "-V",
           "config.cxx=#{ENV.cxx}",
           "config.cc.coptions=-O3",
           "config.cc.loptions=#{loptions}",
           "config.bin.lib=shared",
           "config.bin.rpath='#{rpath}'",
           "config.install.root=#{prefix}",
           "config.import.libsqlite3=",
           "config.build2.libpkgconf=true",
           "config.config.persist='config.*'@unused=drop",
           "configure"

    system "build2/build2/b-boot", "-v",
           "-j", ENV.make_jobs,
           "install:", "build2/", "bpkg/", "bdep/"

    ENV.prepend_path "PATH", bin

    system "b", "-v",
           "-j", ENV.make_jobs,
           "install:", *Dir["libbuild2-*/"]
  end

  test do
    # Suppress loading of default options files.
    ENV["BUILD2_DEF_OPT"] = "0"
    ENV["BPKG_DEF_OPT"] = "0"
    ENV["BDEP_DEF_OPT"] = "0"

    assert_match "build2 #{version}", shell_output("#{bin}/b --version")
    assert_match "bpkg #{version}", shell_output("#{bin}/bpkg --version")
    assert_match "bdep #{version}", shell_output("#{bin}/bdep --version")

    system bin/"bdep", "new", "--type=lib,no-version", "--lang=c++", "libhello"
    (testpath/"libhello/build/root.build").append_lines("using autoconf")
    chdir "libhello" do
      assert_match "project: libhello", shell_output("#{bin}/b info")
      system bin/"bdep", "init", "--config-create", "@default", "cc"
      system bin/"b", "test"
      system bin/"b", "-V", "noop:", "libhello/" # Show configuration report.
    end
  end
end
