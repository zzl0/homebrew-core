class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.3.tar.gz"
  sha256 "a1957826fab7725484fc5b74780a6a7d0d8b7f5e2e54d26e106b399e0a86beb0"
  license "GPL-3.0-only"
  revision 4

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d2f9140f3ba6002dc6ec5a8c899eb2877a0fe9f65f45d57e976a6cd0f6b0c71"
    sha256 cellar: :any,                 arm64_ventura:  "9f003c71502ff19bfdc03e97fe2b103a1c844dc84d62c3e7b6b07e3f8d099e98"
    sha256 cellar: :any,                 arm64_monterey: "9396c5be6a8ab6cf674304b8fb52ac1e80ffda0d24545934298e3f5857fde3ba"
    sha256 cellar: :any,                 sonoma:         "e545205ec152e5073731c12b0186a0e2599a0d6c58c95a78ba1b991362b6520d"
    sha256 cellar: :any,                 ventura:        "d34a74e8b616e7ad01cf71971db1460c2e4af1d167be3313eb4ced10d99e58dc"
    sha256 cellar: :any,                 monterey:       "92a90cec84456001c0f717ec676c312df92e12b5be379465050099a14644cd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24024e26a0d37d273d0f05f79f34b7b74cef30da63b29b97c943d8a0f78bb16b"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "sqlite"

  fails_with gcc: "5"

  patch :DATA # C++ 17 is required

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    (pkgshare/"test").install Dir["test/*.{c,cpp}"]
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system ENV.cc, "select.c", "-L#{lib}", "-lpthread", "-lzdb", "-I#{include}/zdb", "-o", "select"
      system "./select"
    end
  end
end

__END__
diff --git a/src/db/mysql/MysqlConnection.c b/src/db/mysql/MysqlConnection.c
index 45ae896..7b6c1e3 100644
--- a/src/db/mysql/MysqlConnection.c
+++ b/src/db/mysql/MysqlConnection.c
@@ -96,8 +96,10 @@ static MYSQL *_doConnect(Connection_T delegator, char **error) {
         // Options
         if (IS(URL_getParameter(url, "compress"), "true"))
                 clientFlags |= CLIENT_COMPRESS;
-        if (IS(URL_getParameter(url, "use-ssl"), "true"))
-                mysql_ssl_set(db, 0,0,0,0,0);
+        if (IS(URL_getParameter(url, "use-ssl"), "true")) {
+                enum mysql_ssl_mode ssl_mode = SSL_MODE_REQUIRED;
+                mysql_options(db, MYSQL_OPT_SSL_MODE, &ssl_mode);
+        }
 #if MYSQL_VERSION_ID < 80000
         if (IS(URL_getParameter(url, "secure-auth"), "true"))
                 mysql_options(db, MYSQL_SECURE_AUTH, (const char*)&yes);
