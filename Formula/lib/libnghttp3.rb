class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "838def499e368b24d8a4656ad9a1f38bb7ca8b2857a44c5de1c006420cc0bbee"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f5a551e338a3830da79c5860b12cde79117aa3eced2e01df9aac92da7b0b5d3"
    sha256 cellar: :any,                 arm64_ventura:  "2b6f6ed58591e784157a8d6ec51f5449d86f5ea4832469f40f76d1d62b36457d"
    sha256 cellar: :any,                 arm64_monterey: "af79cfbd3df3732fa9a99f773fe1f09a354f323e35d4491418340fedd47bcdf6"
    sha256 cellar: :any,                 sonoma:         "6548d3824898bc17bdf24c970e63021f2ffbe0c7e37e3b8e8b7a7411d0538f7f"
    sha256 cellar: :any,                 ventura:        "adefa167217dc625432e727161b8479f1c75814467334fedbb44b871dcb07b24"
    sha256 cellar: :any,                 monterey:       "0872cfbfb09f67e05f32fb76dabb30e6675919400e075d8def897622980fc6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2819133f6438367824f47e3017dc9c815ca4eee1a03130f310a3ccf774490aad"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_LIB_ONLY=1"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nghttp3/nghttp3.h>

      int main(void) {
        nghttp3_qpack_decoder *decoder;
        if (nghttp3_qpack_decoder_new(&decoder, 4096, 0, nghttp3_mem_default()) != 0) {
          return 1;
        }
        nghttp3_qpack_decoder_del(decoder);
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs libnghttp3").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
