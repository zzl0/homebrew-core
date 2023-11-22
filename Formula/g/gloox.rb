class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.28.tar.bz2"
  sha256 "591bd12c249ede0b50a1ef6b99ac0de8ef9c1ba4fd2e186f97a740215cc5966c"
  license "GPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/Latest stable version.*?href=.*?gloox[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ca7d254e4e398ae137374c1328bb64691b947c55b20ccc45b464cbdb6c99b85"
    sha256 cellar: :any,                 arm64_ventura:  "9b5ae7d3e5cc7ab20100263a57907d0f6ff9b063bd274b20bc7cdc36a11ba229"
    sha256 cellar: :any,                 arm64_monterey: "aa39740f823cbbc7ecfe70d586d3c4cbe003d34c4aca76043a9c4e8c32e78a23"
    sha256 cellar: :any,                 arm64_big_sur:  "e56fbbd9d07dcbc0ed3f8b3d4ca2bf91f7dc6aa1252d0d657ebdc35a8758de49"
    sha256 cellar: :any,                 sonoma:         "4cd82a525604f9b70bd25411cccbeeb086150f142566dfd2a3f3e5ddc711eaed"
    sha256 cellar: :any,                 ventura:        "706aeddbbdfa5b77edb5374df2a5f43205bc061195e1eb716da6331a500fa038"
    sha256 cellar: :any,                 monterey:       "8e12926af004ce4865588035703d4bbce12fbc5a17613f3cc0df03921ddec964"
    sha256 cellar: :any,                 big_sur:        "5b052e56a2286f755a3517f6a0897befa74788af8821f2dd0c52a038c81859a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2b0b46f102fc8d3d0ae4d6398110cce8ab5c1310a64babe1f8944131cfd9966"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # Fix build issue with `{ 0 }`, build patch sent to upstream author
  patch :DATA

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-zlib",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-tests",
                          "--without-examples"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end

__END__
diff --git a/src/tlsopensslclient.cpp b/src/tlsopensslclient.cpp
index ca18096..52322b1 100644
--- a/src/tlsopensslclient.cpp
+++ b/src/tlsopensslclient.cpp
@@ -51,7 +51,11 @@ namespace gloox
     {
       unsigned char buf[32];
       const char* const label = "EXPORTER-Channel-Binding";
-      SSL_export_keying_material( m_ssl, buf, 32, label, strlen( label ), { 0 }, 1, 0 );
+
+      unsigned char context[] = {0}; // Context initialized to zero
+      size_t context_len = sizeof(context); // Length of the context
+
+      SSL_export_keying_material(m_ssl, buf, 32, label, strlen(label), context, context_len, 0);
       return std::string( reinterpret_cast<char* const>( buf ), 32 );
     }
     else
