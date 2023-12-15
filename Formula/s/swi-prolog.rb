class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  stable do
    url "https://www.swi-prolog.org/download/stable/src/swipl-9.0.4.tar.gz"
    sha256 "feb2815a51d34fa81cb34e8149830405935a7e1d1c1950461239750baa8b49f0"

    # Backport fix to build on Sonoma
    patch do
      url "https://github.com/SWI-Prolog/swipl-devel/commit/1e51805f04ea9cb13cf01e5b7a483c03d253b24c.patch?full_index=1"
      sha256 "628b65b3e4a49c8dda4b97824ad05359c48bd27e7e4ddbf914e3da57ef7c87ee"
    end
  end

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "76509c435a4249ef4594c9fe87e6c7543278bc87b9ad0745bccce4d6daf5c384"
    sha256 arm64_monterey: "8f997823471430596e60239443343a4c5c8f6c40d4e65355ce4d7fcd9899fefb"
    sha256 arm64_big_sur:  "9fb8a039478093771a808bf7eed91037ec51444db350f0f2fc3608807e3ef6de"
    sha256 ventura:        "af9904a55d4d2e51ca9b9d3b106d41804e8789a265e986c613f559edc2e3201a"
    sha256 monterey:       "8b483de3ba11170b5165888cc05fe2387bd29f03fb19e841febc3634c6e3f2ff"
    sha256 big_sur:        "2d8b82dde64f73ba269c34a0240f4faf6028521e9a2c581125a38187207baebe"
    sha256 x86_64_linux:   "c51d8ba176d8072047cb43aecbab4eedd1ca48336759d7fed68a8d65648ea0ad"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Remove shim paths from binary files `swipl-ld` and `libswipl.so.*`
    if OS.linux?
      inreplace "cmake/Params.cmake" do |s|
        s.gsub! "${CMAKE_C_COMPILER}", "\"gcc\""
        s.gsub! "${CMAKE_CXX_COMPILER}", "\"g++\""
      end
    end

    args = %W[
      -DSWIPL_PACKAGES_JAVA=OFF
      -DSWIPL_PACKAGES_X=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
    ]
    if OS.mac?
      macosx_dependencies_from = case HOMEBREW_PREFIX.to_s
      when "/usr/local"
        "HomebrewLocal"
      when "/opt/homebrew"
        "HomebrewOpt"
      else
        HOMEBREW_PREFIX
      end
      args << "-DMACOSX_DEPENDENCIES_FROM=#{macosx_dependencies_from}"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
