class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/23.0.0.tar.gz"
  sha256 "6d3afe2a6e3340e2942f654546a1e919242511dede783aff1c8a97a81bc6a706"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sonoma:   "b5b2762373a85ac689bba63de424b99ef30526f4f4bb0558cc725c023074352c"
    sha256 arm64_ventura:  "2011794e7ccea015f660674a621a6416ad12a5cfd5c30ef1d159669f7a171906"
    sha256 arm64_monterey: "94bf68422aeda9711b6f16b380e8445a2c0836bdb2de7b66ca8e06afce0a04d0"
    sha256 sonoma:         "d3731e41a2302c9afa1054d5cd5cadadb41b3f3a495c831cebafabc04f8e87a3"
    sha256 ventura:        "35e0b7326be9baacee241e9e3c49e4f1b831e471636e6b2a0aa80aed903d78e5"
    sha256 monterey:       "d1af934532bd85428bce5defee28f38ddc39d4bc191b5fcea36ac3061b5fa7d0"
    sha256 x86_64_linux:   "546524a5d9849ce0c63f1993f973893906a88550df32727a6779c012d7f216dd"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "bacula-fd", because: "both install a `bconsole` executable"

  # build patch for `sprintf` error, upstream PR ref, https://github.com/bareos/bareos/pull/1636
  patch do
    url "https://github.com/bareos/bareos/commit/bac6e7f30c0ef0df859e62bd1cd47ed563175d2a.patch?full_index=1"
    sha256 "1768352769ee7e5f54831d402e8458ddc13c02bfe18a6d96003b45c64dc8b965"
  end

  def install
    # Work around Linux build failure by disabling warnings:
    # lmdb/mdb.c:2282:13: error: variable 'rc' set but not used [-Werror=unused-but-set-variable]
    # fastlzlib.c:512:63: error: unused parameter ‘output_length’ [-Werror=unused-parameter]
    # Upstream issue: https://bugs.bareos.org/view.php?id=1504
    if OS.linux?
      ENV.append_to_cflags "-Wno-unused-but-set-variable"
      ENV.append_to_cflags "-Wno-unused-parameter"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_PYTHON=OFF",
                    "-Dworkingdir=#{var}/lib/bareos",
                    "-Darchivedir=#{var}/bareos",
                    "-Dconfdir=#{etc}/bareos",
                    "-Dconfigtemplatedir=#{lib}/bareos/defaultconfigs",
                    "-Dscriptdir=#{lib}/bareos/scripts",
                    "-Dplugindir=#{lib}/bareos/plugins",
                    "-Dfd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                    "-Dmon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                    "-Dbasename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dhostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dclient-only=ON",
                    "-DENABLE_LZO=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/bareos").mkpath
    # If no configuration files are present,
    # deploy them (copy them and replace variables).
    unless (etc/"bareos/bareos-fd.d").exist?
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bareos-fd"
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bconsole"
    end
  end

  service do
    run [opt_sbin/"bareos-fd", "-f"]
    require_root true
    log_path var/"run/bareos-fd.log"
    error_log_path var/"run/bareos-fd.log"
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}/bareos-fd -? 2>&1")
    # Check if the configuration is valid.
    system sbin/"bareos-fd", "-t"
  end
end
