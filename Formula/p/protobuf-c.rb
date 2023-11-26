class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "899d76fd1efae4b2404a802994d3ff4d5ff74328ad84aa27602e113f0e84baa0"
    sha256 cellar: :any,                 arm64_ventura:  "f078402e98c0ed0893e7c45f270525d73af1fce025a29b7b7c28e97242e3a911"
    sha256 cellar: :any,                 arm64_monterey: "7a18c6c2e45d5290d915e319b57b835b8506fb41ca0d3d9f801ea6c2bdbacf14"
    sha256 cellar: :any,                 sonoma:         "d121a00c144164896118412cc3997418b1a1ce3f9922f63b7d70ac527d03237e"
    sha256 cellar: :any,                 ventura:        "26dc85759982d07178ea0db8d42e6848aee5c6615f0e651c37779f073a37549f"
    sha256 cellar: :any,                 monterey:       "3ff18ae10399d0a3f22425701e80d93cec1fddb9a97aca831283d5ed9cbcf7b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ab9771ef7748e3d0a4b8c07eb0717b49a43cd5eba2b9deb490bc9a65a710a6"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
