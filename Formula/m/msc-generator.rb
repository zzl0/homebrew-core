class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.5/msc-generator-8.5.tar.gz"
  sha256 "134da30f58458a5ddda0cf6c7a43872636dfc6cae1b8e8a02efe28a0cc9f35d3"
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
    sha256 arm64_sonoma:   "481ba557acc8ca2c54932be8baf663bd93449ae578dcd59711531a636a1acf6b"
    sha256 arm64_ventura:  "9648ffea72f393453dd6127d3c2ddd3ae62536ac9b65f54c82cda7d8c941ffa5"
    sha256 arm64_monterey: "91d386f1a42bc506d0c19816167f2e7da445e5c9c5f26a6829c6c0163eb864fe"
    sha256 sonoma:         "edea0264665d1d70bac7f859b24ceef5b2a98c0e2712546aa27d4e28240419ae"
    sha256 ventura:        "c1147a240cdef6b1dec06dde4ff3c4824e29a47720f6aed5b6b1c8590aaffdc8"
    sha256 monterey:       "349f139e04be1720d13e433d33b8037924ecf52a9fc4a55f022560aed35d0703"
    sha256 x86_64_linux:   "9f52a479c325f00e01cdb5f22226286cb5700ce710b21f6d4182ee4502fe6bf0"
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
    # Some upstream sed discussions in https://gitlab.com/msc-generator/msc-generator/-/issues/92
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
