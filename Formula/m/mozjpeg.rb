class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v4.1.4.tar.gz"
  sha256 "8a5018dc93c08a49fba3aff8d1a0be0a3e26460e315d1db45abb64402935e0db"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "adcd6c15bd49bbf9915c5c913e30fdcbc44a64b1d9fb54b15add4f9dcb4c31d1"
    sha256 cellar: :any,                 arm64_monterey: "4f1dfbac46563db022f793425c7435aba5d5ee9214824fdd4f6099aacb28cd96"
    sha256 cellar: :any,                 arm64_big_sur:  "a391c3e425976d27ba6782c0c9a491439f0b928378da5d5d8cc0a3396c0a3ed5"
    sha256 cellar: :any,                 ventura:        "53c7bc2e054a111de7a0c3fbb235379f73764d231c4de3483881ae018a807448"
    sha256 cellar: :any,                 monterey:       "73b31e0919836222dfc73485d4abc2d67256eeb836725875315a7718ebd3370b"
    sha256 cellar: :any,                 big_sur:        "1f17ab33409735ecdbe46d04b594b1c120ad470c9e4efcf6344b7d7a73d35ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83a66dbe6ac6d15085dab502c1062deb0383dffb62caf5dddfac91a12aa0194f"
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "libpng"

  def install
    mkdir "build" do
      args = std_cmake_args - %w[-DCMAKE_INSTALL_LIBDIR=lib]
      system "cmake", "..", *args, "-DCMAKE_INSTALL_LIBDIR=#{lib}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose", "-optimize",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
  end
end
