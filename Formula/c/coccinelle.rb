class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.lip6.fr/"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  stable do
    url "https://github.com/coccinelle/coccinelle.git",
        tag:      "1.1.1",
        revision: "5444e14106ff17404e63d7824b9eba3c0e7139ba"

    # Backport compatibility with OCaml 5. Remove in the next release.
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/f13b03aa20a08e5187ce36bfd5e606f18acd2888.patch?full_index=1"
      sha256 "84f06551652d9fcee63451fe8d3bce3845c01fe054087cde50bb3b8308014445"
    end
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/1d0733a27006b06eef712f541000a8bf10246804.patch?full_index=1"
      sha256 "391ee079fc18ac4727af089fdf686cd41d4b2ba7847c4bcf2b3b04caf5b6d457"
    end

    # Backport usage of non-bundled packages to allow versions installed by opam
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/3f54340c8ac907e528dbe1475a4a7141e77b9cdd.patch?full_index=1"
      sha256 "94b23b53c023270368601bc5debefc918a99f87b7489e25acddf9c967ddb4486"
    end
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/2afa9f669b565badf17104176cc4850a2dff67f6.patch?full_index=1"
      sha256 "882fe080f7fbce4b0f08b8854a5b02212c17efbc2a62c145eae562842d8e2337"
    end
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/d9ce82a556e313684af74912cf204bb902e04436.patch?full_index=1"
      sha256 "4b27d81d27363efb1a83064abba1df1c09a1f1f064c81cc621ca61b79f58d83e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "c36d64915f8f1fb1d3f1b11affa180d87cce7c2fab525ca5d43e000d6552ac84"
    sha256 arm64_monterey: "6d709b2576f84260edf15ed3a6c4e4b4e0cc73bde3819f9d9085f964c761b155"
    sha256 arm64_big_sur:  "43e22010b8b1f3bf93817d161e2d0e96d907f4a38972d27f91d0231042f70860"
    sha256 ventura:        "7d44848e93251045e263c647aa95c2fd7639ab2918dcdea672ea12115c0f922d"
    sha256 monterey:       "9e00a25cc6afe398d4a5ae42300bacd883bf1f570e6c1523ffb43bd3d330ae30"
    sha256 big_sur:        "270fe7690278277362ebf04707665ae41e3831c21e33d945408f2e7d9737669e"
    sha256 catalina:       "27b442146b362f44848997fa840389ff9df05317e915147d289a74e1ef4c5a68"
    sha256 x86_64_linux:   "29a0aeaeb102990cac27cdc3ecc713f2af6366f38c5d3cefb520ef70dcd2fa84"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "ocaml"
  depends_on "pcre"

  uses_from_macos "unzip" => :build

  def install
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"
      system "./autogen"
      system "opam", "exec", "--", "./configure", *std_configure_args,
                                                  "--disable-silent-rules",
                                                  "--enable-ocaml",
                                                  "--enable-opt",
                                                  "--without-pdflatex",
                                                  "--with-bash-completion=#{bash_completion}"
      ENV.deparallelize
      system "opam", "exec", "--", "make"
      system "make", "install"
    end

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system "#{bin}/spatch", "-sp_file", "#{pkgshare}/simple.cocci",
                            "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS
    assert_equal expected, (testpath/"new_simple.c").read
  end
end
