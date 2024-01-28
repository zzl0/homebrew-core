class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.8.2.tar.gz"
  sha256 "6a1831bfdbf8f424c7508aba47b045d51341ec0fde9122f38b0b86b096ef533e"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb3da9df0a365864c31670497e9c4de44a0b37ef5a0e4aa4782a537c25cc8442"
    sha256 cellar: :any,                 arm64_ventura:  "f71a38aeb0c7441b58f3f3053e6d3d393c30cf6c914ef11c5194eb06c391cb34"
    sha256 cellar: :any,                 arm64_monterey: "02e3599b1bb2d4b09b9bd5bc0bfbeb130399b21f12b69da17835eeca8d4e1a9d"
    sha256 cellar: :any,                 arm64_big_sur:  "53373a88d3f917f29bcd1f1cc7bd400de4b1df7284b95bf0ed9f51dfbc41107b"
    sha256 cellar: :any,                 sonoma:         "c30696920428c87af4cc703d842caf80b91262859264df461dbbb5e5cbdc780a"
    sha256 cellar: :any,                 ventura:        "ba9b4d7ea8f1b00c442398ad5c4b9ef24caf0d5ae0197128732d627bc98bbfdf"
    sha256 cellar: :any,                 monterey:       "597479e27bda9170ed22056191f7433e6c59d7516ad45362d633f4e28345a3b4"
    sha256 cellar: :any,                 big_sur:        "9d88e53ece8634044ef3ddae31ab626e249265d3f8b4456166f4fec89700a49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f301d1855fdf9c3a9cecb4e8a63f180995eda2d0d2f504af6c332762b89c95"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "six" => :build # macOS Python has `six` installed.
  end

  # patch from upstream issue: https://dev.entrouvert.org/issues/85339
  # Remove when https://git.entrouvert.org/entrouvert/lasso/pulls/10/ is merged
  patch :DATA

  def install
    ENV["PYTHON"] = "python3"
    system "./configure", "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
                          "--disable-python",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["libxml2"].include}/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/lasso/xml/tools.c b/lasso/xml/tools.c
index 4d5fa78a..0478f3f4 100644
--- a/lasso/xml/tools.c
+++ b/lasso/xml/tools.c
@@ -64,6 +64,7 @@
 #include <glib.h>
 #include "xml.h"
 #include "xml_enc.h"
+#include "id-ff/server.h"
 #include "saml-2.0/saml2_assertion.h"
 #include <unistd.h>
 #include "../debug.h"
@@ -309,7 +310,7 @@ xmlSecKeyPtr lasso_get_public_key_from_pem_file(const char *file) {
 			pub_key = lasso_get_public_key_from_pem_cert_file(file);
 			break;
 		case LASSO_PEM_FILE_TYPE_PUB_KEY:
-			pub_key = xmlSecCryptoAppKeyLoad(file,
+			pub_key = xmlSecCryptoAppKeyLoadEx(file, xmlSecKeyDataTypePublic | xmlSecKeyDataTypePrivate,
 					xmlSecKeyDataFormatPem, NULL, NULL, NULL);
 			break;
 		case LASSO_PEM_FILE_TYPE_PRIVATE_KEY:
@@ -378,7 +379,7 @@ lasso_get_public_key_from_pem_cert_file(const char *pem_cert_file)
 static xmlSecKeyPtr
 lasso_get_public_key_from_private_key_file(const char *private_key_file)
 {
-	return xmlSecCryptoAppKeyLoad(private_key_file,
+	return xmlSecCryptoAppKeyLoadEx(private_key_file, xmlSecKeyDataTypePrivate | xmlSecKeyDataTypePublic,
 			xmlSecKeyDataFormatPem, NULL, NULL, NULL);
 }
 
@@ -2704,7 +2705,7 @@ cleanup:
 xmlSecKeyPtr
 lasso_xmlsec_load_key_info(xmlNode *key_descriptor)
 {
-	xmlSecKeyPtr key, result = NULL;
+	xmlSecKeyPtr key = NULL, result = NULL;
 	xmlNodePtr key_info = NULL;
 	xmlSecKeyInfoCtx ctx = {0};
 	xmlSecKeysMngr *keys_mngr = NULL;
@@ -2738,6 +2739,17 @@ lasso_xmlsec_load_key_info(xmlNode *key_descriptor)
 	ctx.keyReq.keyUsage = xmlSecKeyDataUsageAny;
 	ctx.certsVerificationDepth = 0;
 
+	if((xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataX509Id) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataValueId) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataRsaId) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataDsaId) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataHmacId) < 0)) {
+		message(G_LOG_LEVEL_CRITICAL, "Could not enable needed KeyData");
+		goto next;
+	}
+
+
+
 	key = xmlSecKeyCreate();
 	if (lasso_flag_pem_public_key) {
 		xmlSecErrorsDefaultCallbackEnableOutput(FALSE);
diff --git a/lasso/xml/xml.c b/lasso/xml/xml.c
index 0d5c6e31..09cc3037 100644
--- a/lasso/xml/xml.c
+++ b/lasso/xml/xml.c
@@ -620,6 +620,10 @@ lasso_node_encrypt(LassoNode *lasso_node, xmlSecKey *encryption_public_key,
 		goto cleanup;
 	}
 
+#if (XMLSEC_MAJOR > 1) || (XMLSEC_MAJOR == 1 && XMLSEC_MINOR > 3) || (XMLSEC_MAJOR == 1 && XMLSEC_MINOR == 3 && XMLSEC_SUBMINOR >= 0)
+	enc_ctx->keyInfoWriteCtx.flags |= XMLSEC_KEYINFO_FLAGS_LAX_KEY_SEARCH;
+#endif
+
 	/* generate a symetric key */
 	switch (encryption_sym_key_type) {
 		case LASSO_ENCRYPTION_SYM_KEY_TYPE_AES_256:
