class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.4.2/msc-generator-8.4.2.tar.gz"
  sha256 "cdf79780a3e20c315fea8945fcdb1627b6df0634ee18ab037e1a2f2ffbb5698b"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://gitlab.com/api/v4/projects/31167732/packages"
    strategy :json do |json|
      json.map do |item|
        next unless item["name"]&.downcase&.include?("msc-generator")

        item["version"]
      end
    end
  end

  bottle do
    sha256 arm64_ventura:  "76278d5fa2ce33e4e1f2ebcc27d1eb6fc6861f6c4dff0d888ab98d37b6720686"
    sha256 arm64_monterey: "d6c721135921bd819cea49c2f02693d357ca0218ba230a765c12284218cbdcb9"
    sha256 arm64_big_sur:  "c20c6559cb104390b8698e8cc97bf54d8c1e0d250f92c558fa6088c6fab3c8e0"
    sha256 ventura:        "216a07418371d93713f5841fdf096159f279a7d1e13005e534ecfa0c109a8fae"
    sha256 monterey:       "48cb526ca7471152b121ea2e3e9859111b5963c08b361ceea3aaea85f31425a8"
    sha256 big_sur:        "e375256edabd34d86a4539796d31ffc7fe1426c5a41b176e0a76fcd4b7f9314c"
    sha256 x86_64_linux:   "c5e7880a5dc72e8e053f3e686ec469cf1ab9a028016f1c290cc39231ef80bd9a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"
  depends_on "tinyxml2"

  on_macos do
    # Check if upstream still requires GNU sed and GNU make 4.3+ in future release.
    # Issue ref: https://gitlab.com/msc-generator/msc-generator/-/issues/92
    depends_on "gnu-sed" => :build
    depends_on "make" => :build # needs make 4.3+
    depends_on "gcc"
  end

  on_linux do
    depends_on "mesa"
  end

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "9"
    cause "needs std::range"
  end

  # Use upstream MR to fix build on macOS. Remove if merged and in release.
  # Issue ref: https://gitlab.com/msc-generator/msc-generator/-/issues/90
  # PR ref: https://gitlab.com/msc-generator/msc-generator/-/merge_requests/154
  patch do
    url "https://gitlab.com/msc-generator/msc-generator/-/commit/a4d9ef77f797d33970882b1d7639b872f2ced126.diff"
    sha256 "0cae8315f0aafdb68ccfe94b15da278cd28355a65e7fe30bfc4475d1d0f117e0"
  end

  # Backport compatibility with graphviz 9.0
  # TODO: Remove in next release along with `autoreconf` usage in install
  # Ref: https://gitlab.com/msc-generator/msc-generator/-/commit/41cf4b85cbe4f77cda0ce6c6835eec5f71016aec
  patch :DATA

  def install
    args = %w[--disable-font-checks --disable-silent-rules]
    make = "make"

    # Brew uses shims to ensure that the project is built with a single compiler.
    # However, gcc cannot compile our Objective-C++ sources (clipboard.mm), while
    # clang++ cannot compile the rest of the project. As a workaround, we set gcc
    # as the main compiler, and bypass brew's compiler shim to force using clang++
    # for Objective-C++ sources. This workaround should be removed once brew supports
    # setting separate compilers for C/C++ and Objective-C/C++.
    if OS.mac?
      args << "OBJCXX=/usr/bin/clang++"
      ENV.append_to_cflags "-DNDEBUG"
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      ENV["MAKE"] = make = "gmake"
    end

    # Regenerate configure for patch.
    # TODO: Remove in the next release.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args, *std_configure_args
    system make, "-C", "src", "install"
    system make, "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 756235627e79ec3d7a317cb91d7f3e3634c6ddc1..1d157860156482d7b624da97c36647f5d8aec753 100644
--- a/configure.ac
+++ b/configure.ac
@@ -16,8 +16,10 @@ AC_ARG_VAR([BISON], [bison command])
 AC_CHECK_PROGS([BISON], [bison], [:])
 AC_CHECK_PROGS([FCMATCH], [fc-match], [:])
 PKG_CHECK_MODULES(CAIRO, cairo >= 1.12.0)
-PKG_CHECK_MODULES(GRAPHVIZ, libgvc >= 2.49.0, [AC_DEFINE([GRAPHVIZ_POST_2_49], [1])], [
-    PKG_CHECK_MODULES(GRAPHVIZ, libgvc >= 2.36.0)])
+PKG_CHECK_MODULES(GRAPHVIZ, libgvc >= 9.0.0, [AC_DEFINE([GRAPHVIZ_VER], [900])], [
+    PKG_CHECK_MODULES(GRAPHVIZ, libgvc >= 8.0.0, [AC_DEFINE([GRAPHVIZ_VER], [800])], [
+        PKG_CHECK_MODULES(GRAPHVIZ, libgvc >= 2.49.0, [AC_DEFINE([GRAPHVIZ_VER], [249])], [
+            PKG_CHECK_MODULES(GRAPHVIZ, libgvc >= 2.36.0, [AC_DEFINE([GRAPHVIZ_VER], [236])])])])])
 PKG_CHECK_MODULES(TINYXML, tinyxml2 >= 8)
 PKG_CHECK_MODULES(LIBPNG, libpng >= 1.6)
 AC_CHECK_HEADER([glpk.h],
diff --git a/src/libgvgen/gvgraphs.cpp b/src/libgvgen/gvgraphs.cpp
index 0a4a86cd015a82445ca3eeff9c0884b50125288a..0ec6149523761f0a3dde5721a39ecd4352321176 100644
--- a/src/libgvgen/gvgraphs.cpp
+++ b/src/libgvgen/gvgraphs.cpp
@@ -66,7 +66,12 @@ std::set<std::string> GetLayoutMethods()
 {
     std::set<std::string> ret;
     int size;
-    for (char **list = gvPluginList(Gvc, const_cast<char*>("layout"), &size, nullptr); size; size--, list++)
+#if GRAPHVIZ_VER >= 900
+    char** list = gvPluginList(Gvc, const_cast<char*>("layout"), &size);
+#else
+    char** list = gvPluginList(Gvc, const_cast<char*>("layout"), &size, nullptr);
+#endif
+    for (; size; size--, list++)
         ret.emplace(*list);
     return ret;
 }
@@ -1050,7 +1055,7 @@ void canvas_cover_polygon(bool draw, GVJ_t * job, pointf * A, int n, int filled)
 
 /** Callback called by graphviz to draw a curve - we extract it and save as a drawing primitive
  * into Graph::_current or actually draw it on Graph::_current->_canvas, if 'draw' is true.*/
-void canvas_cover_beziercurve(bool draw, GVJ_t * job, pointf * A, int n, int /*arrow_at_start*/, int /*arrow_at_end*/, int filled)
+void canvas_cover_beziercurve(bool draw, GVJ_t * job, pointf * A, int n, int filled)
 {
     if (Graph::_current==nullptr || Graph::_current->_canvas==nullptr) return;
     Path p;
@@ -1160,9 +1165,14 @@ void cover_polygon(GVJ_t * job, pointf * A, int n, int filled)
     canvas_cover_polygon(false, job, A, n, filled);
 }
 
-void cover_beziercurve(GVJ_t * job, pointf * A, int n, int arrow_at_start, int arrow_at_end, int filled)
+#if GRAPHVIZ_VER >= 800
+void cover_beziercurve(GVJ_t* job, pointf* A, int n, int filled)
+#else
+void cover_beziercurve(GVJ_t * job, pointf * A, int n, int /*arrow_at_start*/, int /*arrow_at_end*/, int filled)
+#endif
+
 {
-    canvas_cover_beziercurve(false, job, A, n, arrow_at_start, arrow_at_end, filled);
+    canvas_cover_beziercurve(false, job, A, n, filled);
 }
 
 void cover_polyline(GVJ_t * job, pointf * A, int n)
@@ -1203,7 +1213,7 @@ gvrender_engine_t cover_render_engine = {
     nullptr,               //(*resolve_color) (GVJ_t * job, gvcolor_t * color);
     cover_ellipse,      //(*ellipse) (GVJ_t * job, pointf * A, int filled);
     cover_polygon,      //(*polygon) (GVJ_t * job, pointf * A, int n, int filled);
-    cover_beziercurve,  //(*beziercurve) (GVJ_t * job, pointf * A, int n, int arrow_at_start, int arrow_at_end, int);
+    cover_beziercurve,  //(*beziercurve) (GVJ_t * job, pointf * A, int n, int arrow_at_start, int arrow_at_end, int); after graphviz 7.0: (GVJ_t * job, pointf * A, int n, int arrow_at_start, int arrow_at_end, int);
     cover_polyline,     //(*polyline) (GVJ_t * job, pointf * A, int n);
     nullptr,               //(*comment) (GVJ_t * job, char *comment);
     nullptr,               //(*library_shape) (GVJ_t * job, char *name, pointf * A, int n, int filled);
@@ -1273,9 +1283,13 @@ void canvas_polygon(GVJ_t * job, pointf * A, int n, int filled)
     canvas_cover_polygon(true, job, A, n, filled);
 }
 
-void canvas_beziercurve(GVJ_t * job, pointf * A, int n, int arrow_at_start, int arrow_at_end, int filled)
+#if GRAPHVIZ_VER >= 800
+void canvas_beziercurve(GVJ_t* job, pointf* A, int n, int filled)
+#else
+void canvas_beziercurve(GVJ_t * job, pointf * A, int n, int /*arrow_at_start*/, int /*arrow_at_end*/, int filled)
+#endif
 {
-    canvas_cover_beziercurve(true, job, A, n, arrow_at_start, arrow_at_end, filled);
+    canvas_cover_beziercurve(true, job, A, n, filled);
 }
 
 void canvas_polyline(GVJ_t * job, pointf * A, int n)
diff --git a/src/libgvgen/gvgraphs.h b/src/libgvgen/gvgraphs.h
index a6dfbc125b5b4df6377d3a60b3a391bc27b5dbac..38c86bfd3b10f8fa190051660d53b93934b3fe55 100644
--- a/src/libgvgen/gvgraphs.h
+++ b/src/libgvgen/gvgraphs.h
@@ -28,6 +28,10 @@
 #include "gvstyle.h"
 #include "chartbase.h"
 
+#ifndef GRAPHVIZ_VER
+#error Need graphviz!
+#endif
+
 /** @name Types & externs copied from cgraph.h: forward declare cgraph types, so we do not have to include the whole cgraph library here
  ** @{ */
 typedef struct Agraph_s Agraph_t;	///<graph, subgraph (or hyperedge) (copied from cgraph.h of graphviz)
@@ -36,7 +40,7 @@ typedef struct Agedge_s Agedge_t;	///<node pair (copied from cgraph.h of graphvi
 typedef struct Agsym_s Agsym_t; ///<symbol (copied from cgraph.h of graphviz)
 typedef struct GVC_s GVC_t; ///<global gvc context (copied from cgraph.h of graphviz)
 typedef struct obj_state_s obj_state_t; ///<generic object (node, edge, graph, etc.) (copied from cgraph.h of graphviz)
-#ifndef GRAPHVIZ_POST_2_49
+#if GRAPHVIZ_VER < 249
 extern "C" void *agbindrec(void *obj, char *name, unsigned int size, int move_to_front);
 extern "C" int agxset(void *obj, Agsym_t * sym, char *value);
 extern "C" int agset(void *obj, char *name, char *value);
@@ -53,7 +57,7 @@ extern "C" Agedge_t *agedge(Agraph_t * g, Agnode_t * t, Agnode_t * h, char *name
 
 /** @name wrappers for passing const char* parameters to cgraph functions
  ** @{ */
-#ifndef GRAPHVIZ_POST_2_49
+#if GRAPHVIZ_VER < 249
 inline void *agbindrec(void *obj, const char *name, unsigned int size, int move_to_front) { return agbindrec(obj, const_cast<char*>(name), size, move_to_front); }
 inline int agxset(void *obj, Agsym_t * sym, const char *value) {return agxset(obj, sym, const_cast<char*>(value)); }
 #endif
