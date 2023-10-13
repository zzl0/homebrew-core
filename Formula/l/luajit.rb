# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https://github.com/Homebrew/homebrew-core/pull/99580
# TODO: Add an audit in `brew` for this. https://github.com/Homebrew/homebrew-core/pull/104765
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  # Update this to the tip of the `v2.1` branch at the start of every month.
  # Get the latest commit with:
  #   `git ls-remote --heads https://github.com/LuaJIT/LuaJIT.git v2.1`
  # This is a rolling release model so take care not to ignore CI failures that may be regressions.
  url "https://github.com/LuaJIT/LuaJIT/archive/656ecbcf8f669feb94e0d0ec4b4f59190bcd2e48.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1696795921"
  sha256 "b73cc2968a16435e899a381d36744f65e3a2d6688213fcbce95aeac56ce38d53"
  license "MIT"
  head "https://luajit.org/git/luajit.git", branch: "v2.1"

  livecheck do
    url "https://github.com/LuaJIT/LuaJIT/commits/v2.1"
    regex(/<relative-time[^>]+?datetime=["']?(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)["' >]/im)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "2.1.#{DateTime.parse(match[0]).strftime("%s")}" }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "57d50c2d1286f22e6aec725ea351ecd7dc094cf2a01765a27dc3d9cee4083b12"
    sha256 cellar: :any,                 arm64_ventura:  "83ff44fbfaa9312b80ee92c80c2683eccdf7f997bdd6608d1b0bcf2057f48b9c"
    sha256 cellar: :any,                 arm64_monterey: "46066e754a2d030fc781a9865cde2d50cc2eb76ba565005ec7ac3ffb7d0e298b"
    sha256 cellar: :any,                 arm64_big_sur:  "e231ae553b2f134916e28bc43e34f82c1b99d2c22c4977ed03701224a37de8c5"
    sha256 cellar: :any,                 sonoma:         "ef7255ee32feaa58467e4dc7f2fb0e41c47a0c511f017c82e5f93c9e6869d69f"
    sha256 cellar: :any,                 ventura:        "7703055988274d4d9acd8e04b28a937db7a3e5d31531d8f555cb715c1e794cbc"
    sha256 cellar: :any,                 monterey:       "ca3ac71bd6f9ae3854e046e7ebca55a9d427197d42b55e656c831fc9cc4f87b1"
    sha256 cellar: :any,                 big_sur:        "98918574b3945dbdbab7f0e7952dd1482bdbffb0fd5fe26b3c806542bfb09222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a3de845d0a769045d2bab5337762d7bcb6b31a52a1e28fcfa1ab0c308dc0db"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.gsub!(/-march=\w+\s?/, "")
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    # Help the FFI module find Homebrew-installed libraries.
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: HOMEBREW_PREFIX/"lib")}" if HOMEBREW_PREFIX.to_s != "/usr/local"

    # Pass `Q= E=@:` to build verbosely.
    verbose_args = %w[Q= E=@:]

    # Build with PREFIX=$HOMEBREW_PREFIX so that luajit can find modules outside its own keg.
    # This allows us to avoid having to set `LUA_PATH` and `LUA_CPATH` for non-vendored modules.
    system "make", "amalg", "PREFIX=#{HOMEBREW_PREFIX}", *verbose_args
    system "make", "install", "PREFIX=#{prefix}", *verbose_args
    doc.install (buildpath/"doc").children

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/shared_library("libluajit-5.1") => shared_library("libluajit")
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
    end
  end

  test do
    assert_includes shell_output("#{bin}/luajit -v"), " #{version} "

    system bin/"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS

    # Check that LuaJIT can find its own `jit.*` modules
    touch "empty.lua"
    system bin/"luajit", "-b", "-o", "osx", "-a", "arm64", "empty.lua", "empty.o"
    assert_predicate testpath/"empty.o", :exist?

    # Check that we're not affected by LuaJIT/LuaJIT/issues/865.
    require "macho"
    machobj = MachO.open("empty.o")
    assert_kind_of MachO::FatFile, machobj
    assert_predicate machobj, :object?

    cputypes = machobj.machos.map(&:cputype)
    assert_includes cputypes, :arm64
    assert_includes cputypes, :x86_64
    assert_equal 2, cputypes.length
  end
end
