class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.1.tar.gz"
  sha256 "79d23595ef95d61d3d728ae5e60850a3dbfbf58a46953b4fdc8e6e0ffe5748ba"
  license "MIT"
  revision 3

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a9328a2fa4b76d6d5964c784bc7eadbb7e7f3f98d08aae73764596a2c47d8a2"
    sha256 cellar: :any,                 arm64_ventura:  "371eb1dc1c10bc91169e83577d5c5ecc495db143d3f370657e861ea7902a0ffa"
    sha256 cellar: :any,                 arm64_monterey: "71203d65b7e9487cffa0a338ff9f50758a5b990fd97faceba3efdd91d095212e"
    sha256 cellar: :any,                 sonoma:         "4901feb3b0dc316c39ae64e7e41099e2e45e2d70a40190db8d74db31accfe0d9"
    sha256 cellar: :any,                 ventura:        "161613d7762d5994bc388c34a9f664252f361d23b6422c53440ecb861dbdb321"
    sha256 cellar: :any,                 monterey:       "b59087c10921d87314f5061e444a6a7e99d0f3603dce6ee325c2bb7aba00d3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff58cbd98e7a8d71e777ce1a6e4476456f7e01611a5cdd417b2ebb538cc0651"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.12"

  uses_from_macos "curl"

  fails_with gcc: "5"

  # Backport fix for libxml2 2.12.
  # Ref: https://github.com/MapServer/MapServer/commit/2cea5a12a35b396800296cb1c3ea08eb00b29760
  patch :DATA

  def python3
    "python3.12"
  end

  def install
    # Install within our sandbox
    inreplace "mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}", "-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DWITH_CLIENT_WFS=ON",
                    "-DWITH_CLIENT_WMS=ON",
                    "-DWITH_CURL=ON",
                    "-DWITH_FCGI=ON",
                    "-DWITH_FRIBIDI=OFF",
                    "-DWITH_GDAL=ON",
                    "-DWITH_GEOS=ON",
                    "-DWITH_HARFBUZZ=OFF",
                    "-DWITH_KML=ON",
                    "-DWITH_OGR=ON",
                    "-DWITH_POSTGIS=ON",
                    "-DWITH_PYTHON=ON",
                    "-DWITH_SOS=ON",
                    "-DWITH_WFS=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPHP_EXTENSION_DIR=#{lib}/php/extensions"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args, "./build/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end

__END__
diff --git a/mapows.c b/mapows.c
index f141a7b..5a94ecb 100644
--- a/mapows.c
+++ b/mapows.c
@@ -168,7 +168,7 @@ static int msOWSPreParseRequest(cgiRequestObj *request,
 #endif
     if (ows_request->document == NULL
         || (root = xmlDocGetRootElement(ows_request->document)) == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_OWSERR, "XML parsing error: %s",
                  "msOWSPreParseRequest()", error->message);
       return MS_FAILURE;
diff --git a/mapwcs.cpp b/mapwcs.cpp
index 70e63b8..19afa79 100644
--- a/mapwcs.cpp
+++ b/mapwcs.cpp
@@ -362,7 +362,7 @@ static int msWCSParseRequest(cgiRequestObj *request, wcsParamsObj *params, mapOb
     /* parse to DOM-Structure and get root element */
     if((doc = xmlParseMemory(request->postrequest, strlen(request->postrequest)))
         == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_WCSERR, "XML parsing error: %s",
                  "msWCSParseRequest()", error->message);
       return MS_FAILURE;
diff --git a/mapwcs20.cpp b/mapwcs20.cpp
index b35e803..2431bdc 100644
--- a/mapwcs20.cpp
+++ b/mapwcs20.cpp
@@ -1446,7 +1446,7 @@ int msWCSParseRequest20(mapObj *map,

     /* parse to DOM-Structure and get root element */
     if(doc == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_WCSERR, "XML parsing error: %s",
                  "msWCSParseRequest20()", error->message);
       return MS_FAILURE;
