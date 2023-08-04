class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  license "LGPL-2.1-only"
  revision 1
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  stable do
    url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.1.0/libgit2-glib-v1.1.0.tar.bz2"
    sha256 "6cbbf43eda241cc8602fc22ccd05bbc4355d9873634bc12576346e6b22321f03"

    # Add commit signing API. Needed for dependent `gitg`.
    # Remove with `stable` block on next release.
    patch do
      url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/commit/7f36e18f41e0b28b35c85fe8bf11d844a0001305.diff"
      sha256 "e5a07c6bbd05b88f1d52107167d7db52f43abfd0b367645cc75b72acb623d9ff"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "da5d582b254f236579b01f4536c081d62a82f327c0acf64702dc7eceb5d286ba"
    sha256 cellar: :any, arm64_monterey: "204dfde122f901d839afa4ed1c6fddc9eece5c9010387af5659c64951eaaf413"
    sha256 cellar: :any, arm64_big_sur:  "0bebc4fb5137e71b0f09a761e7b33892662da13da94ded1d8f3a30fdfaff961e"
    sha256 cellar: :any, ventura:        "2188c465de6e9974292f6d14ba5c5b12557cef53c0b8430859d6901f7241be54"
    sha256 cellar: :any, monterey:       "768a60660e8de0fbae6dab7ea17d5d4a0ead85d10be00927a76e870dc27f0182"
    sha256 cellar: :any, big_sur:        "ad68b43e1911110761fa4c861b0106721168e93336b71984dbcb7d6260f9e0da"
    sha256               x86_64_linux:   "69c65a0177a78fec07f3c73622f719e2d88603cbfc8b9b1e464b9b3ef034c290"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", "setup", "build", *std_meson_args,
                                      "-Dpython=false",
                                      "-Dvapi=true"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    libexec.install (buildpath/"build/examples").children
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
