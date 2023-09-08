class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.102/ortp-5.2.102.tar.bz2"
  sha256 "d7a270d502009a787c5bd53ca9db8cc52a714e3a014f23944d4198efd3c7e4ee"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d12f6b1c21e9634496f41edfc761d4ec89a6146740a9259ef8a490b251538927"
    sha256 cellar: :any,                 arm64_monterey: "3f46c3ba32523abcc1906a32ec72cbde694b3bcb7bc3db4ad2ba8718b0bc7a11"
    sha256 cellar: :any,                 arm64_big_sur:  "08a3cf22477e1163c8e72c3b269783fc0ddfc50e4eb998e99bf553cfa0f946ba"
    sha256 cellar: :any,                 ventura:        "55d4630800f8f0160e81cb5e653b0544c15cc3fbc42a90ebd241b60ec659ba89"
    sha256 cellar: :any,                 monterey:       "6387a658b41a1a37a4e436b5ed031b05ac7b1247c7899f94877fe80fad6928db"
    sha256 cellar: :any,                 big_sur:        "d4a612ba2549bf0d62d24908c0d2759f9b8ef4c7034226594651f2cdaba60061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df577df1c6f476b3b80192f4f66316b2b64650f8256582f68b0ff1a0e84239b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.102/bctoolbox-5.2.102.tar.bz2"
    sha256 "0b6287d89780b94866b879c09504a9f90f3dceebd5536303e700042a4b254c4a"
  end

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF"]
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
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]

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
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
