class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.5/ortp-5.3.5.tar.bz2"
    sha256 "65459d91c40aedb99c80ee86b12ea29f1a275e0d6fe2acaf40b7ce542074f2c9"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.5/bctoolbox-5.3.5.tar.bz2"
      sha256 "d1dbbfe05fea4623e93469fd7dcf374c8680f461acfe8afc6ad22d651ec63320"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0de6426e96809a842733929c171a2414d9ecf38c1a71da371467d0dddb9b4551"
    sha256 cellar: :any,                 arm64_ventura:  "2c809500c163fcca0f93f631aacea3b0b9da2cc2bb32a0bb7e4f465554b20236"
    sha256 cellar: :any,                 arm64_monterey: "a41db4fa8a1e0f140d928610130fa0e5ab84163173305cc31d218f3b12c105cc"
    sha256 cellar: :any,                 sonoma:         "35e1c71eec6328ed2ff53757c0da6f09d4cef25a1e8bf3d549d909a2799a3bb9"
    sha256 cellar: :any,                 ventura:        "4bc7bc99ebb96e2fce4ef5d8d3c1a87e01a0c01e1149d9c56ff12ac5b8850fac"
    sha256 cellar: :any,                 monterey:       "c2f679851f05f26443493c3865f71441d6ad7690bd80f043f8aa37dded047fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27626d0fa3df737435cbb9e5d327bdbadb538e5c841c09e1059dfaee4d73b24"
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
