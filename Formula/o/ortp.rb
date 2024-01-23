class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.12/ortp-5.3.12.tar.bz2"
    sha256 "704bf07a811e52e1c063cc0eb8709d84bf0c3bcd942b0c1175f01257c0fff6be"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.12/bctoolbox-5.3.12.tar.bz2"
      sha256 "ab95ac71ef1bd08a4b8dbc75f9b74c341eb3da2b0c7f6a5949e3489b09999d2a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4d337d12eadf2f5dae31b770b093c785456f2f217145c9e98d5b9dea0fb0293"
    sha256 cellar: :any,                 arm64_ventura:  "eef9dc17978daad810c8536ab2971a6ccc74c063f2441545d9a11817fc7d846b"
    sha256 cellar: :any,                 arm64_monterey: "ab5fb8d49975c4e5432c2ecb1b2e8583a76cb970f6b9fa06abb7b3ba3913f368"
    sha256 cellar: :any,                 sonoma:         "2a02922f9467e666c220216a2ec4c86a0ebb309369dcd3556a7304f03105275f"
    sha256 cellar: :any,                 ventura:        "69d45bc5c0cfefff6e05ea49a4d8dec77e78fe5440dbacd331e34eb1dcc9a737"
    sha256 cellar: :any,                 monterey:       "f89e2636300b7bd2201460e86fea11bd45067fdfe614f2bcaa28e75d950e6b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef3c9ee6c236e425e130e27c549016f5ba54d6ca4bd63a9a26f6043e12a339aa"
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
