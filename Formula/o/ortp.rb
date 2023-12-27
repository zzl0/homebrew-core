class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.1/ortp-5.3.1.tar.bz2"
    sha256 "065f77a9b0f710d879581d20f0dbb7fda451835580ebafe4dc0b0ddb45112054"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.1/bctoolbox-5.3.1.tar.bz2"
      sha256 "b3e9836913e3eb7d53fdfe65e0e93e9b5f4f260e0ca4cd6ccf9febf64bf616d9"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77baf9a3409f0a886f93c1280802997389a7e38bde90742461240da010e200a9"
    sha256 cellar: :any,                 arm64_ventura:  "5be430f82fc6efaf6c51cd4caa17f28dc5b9b8f97dcfb752ae8fcfb430247e34"
    sha256 cellar: :any,                 arm64_monterey: "5734d0240c674d746aaf44393120fb779333864961bac686b3e46b63592bf155"
    sha256 cellar: :any,                 sonoma:         "bc048e3977e8ef87ae5ff120640870824da2d821429b8d1f54d591fb2736914e"
    sha256 cellar: :any,                 ventura:        "344b22cc730fcc26693d4d416e3e4ae54acc9ad9430e2316b58903dbb5d68f3d"
    sha256 cellar: :any,                 monterey:       "61bf1c672d6131ca82d94596519d2777b59379668c7b6ef33045a84291779ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338aa9c74ea0f276bbd2679f7cb6ac8dbeabf38ed59d972aed3bdc8426a3499b"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF", "-DBUILD_SHARED_LIBS=ON"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{libexec}/Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}/include", *linker_flags
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
