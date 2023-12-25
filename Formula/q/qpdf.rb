class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.7.0/qpdf-11.7.0.tar.gz"
  sha256 "f14a6ede3b7deb6bec1e327beeeb2e508e1a74aa7e62fbaa6f62d09c96627541"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d07bb99309f365f90f2e548818a72d865e251b5b46d4e12b23372531558e25e"
    sha256 cellar: :any,                 arm64_ventura:  "a977ed87b022263c92d03c212f692b06918574603f9ea5b1655345e9b1ba8baa"
    sha256 cellar: :any,                 arm64_monterey: "d65dc609abad83ac5b4fc3ad71107eec6e6485e8e99bb4e6ee0975aaae9d4ad3"
    sha256 cellar: :any,                 sonoma:         "e7269c65bd7bff063fc8669d48390fc28b1882591b27d0898342eb7b9871c5c9"
    sha256 cellar: :any,                 ventura:        "631a1f441a0049135f2e478ae69c2bd99220ed59b9ec8f474ef000225ef40b42"
    sha256 cellar: :any,                 monterey:       "1b273e017a9bf2fea3b60fce72dd77c9e8b89b1c63997b617790c103fb99755c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71abb4391ffad443305bcbd0e7883b8d418d20e1713d9ec38345974fd283e4d4"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
