class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.15.1-2.tar.gz"
  sha256 "c9d6bab6593bfe716e8c4ed30be2bf7d309c1211bd7b8ed27387d373e9932742"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bc489a6c4f1f45d59f5ff875f124a10550eb8f5ca94a4ddde1b74fc39ae0ca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f74f2395b2cb03e3c8ab90d84f47d747ff771cc8bbbcd847ad58089256507d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "266496fa500dec17ac947dce37f58914f20a97860e7de18e00906aebcabc12f8"
    sha256 cellar: :any_skip_relocation, ventura:        "717a1c10447d521a48b614e318b35e70799efdcffcc50f96be97c2d2bce128c1"
    sha256 cellar: :any_skip_relocation, monterey:       "464076349b1068f9b6aeb138e505031b8b290d1c23a275fcdd55fd0491bfe2bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d8270058c62e0fb4271a4e4c333f44fe2569ec2f53e436c4ceaddae226bb646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c50902cd52e6f97ef3e30f027dfdafb6672f0d6f8a54cf5900641805bba3ec"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "pcre"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib/shared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    if OS.mac?
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1"
      args << "-DZLIB_INCLUDE_DIRS=/usr/include"
      args << "-DZLIB_LIBRARIES=-lz"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
