class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.1/chromaprint-1.5.1.tar.gz"
  sha256 "a1aad8fa3b8b18b78d3755b3767faff9abb67242e01b478ec9a64e190f335e1c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "052ef41914f72d70ffd4bf09080bb9fabee04fa3831d040da2b1807434555c97"
    sha256 cellar: :any,                 arm64_ventura:  "9df7a9b08cf6557f60d607c26c2fec7644ed9c1ebb0291113930b02e2ca8c33c"
    sha256 cellar: :any,                 arm64_monterey: "d4479962c7c30dbc07c8d4639639198e8de0015f35ce7e3ac47c5e87e492333f"
    sha256 cellar: :any,                 arm64_big_sur:  "8ce15ae4efe13275af05b62e83fbcde65644d7baee3dd4ae37fae7007396b80c"
    sha256 cellar: :any,                 sonoma:         "7aff1d8a3015c00f77013efba51891b6f636e3958aab7cb26804beb12c5b0073"
    sha256 cellar: :any,                 ventura:        "f3457e6b097e705e87d4c54ec7335c59365b7b307830ede26123810ae51eb0ba"
    sha256 cellar: :any,                 monterey:       "86d59168bfd57c19029084ea626953a99976361f4d0aadcdc6d51fbda8b8ca6b"
    sha256 cellar: :any,                 big_sur:        "f9df429a357d408b65f6e1e5effc720005bb75bc10e069891acbba25430b755d"
    sha256 cellar: :any,                 catalina:       "935e7dbb82458a6dd276b3265d8df41390c6aa236cbdf4ef4287662961f5d97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aecf570ed20d986f95f0071c52c0cca65eb96ef6d308a60d83529b1f16984682"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  # Backport support for FFmpeg 5+. Remove in the next release
  patch do
    url "https://github.com/acoustid/chromaprint/commit/584960fbf785f899d757ccf67222e3cf3f95a963.patch?full_index=1"
    sha256 "b9db11db3589c5f4a2999c1a782bd41f614d438f18a6ed3b5167165d0863f9c2"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/8ccad6937177b1b92e40ab8f4447ea27bac009a7.patch?full_index=1"
    sha256 "47c9cc257c6e5d46840e9b64ba5f1bcee2705eac3d7f5b23ca0fb4aefc6b8189"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/aa67c95b9e486884a6d3ee8b0c91207d8c2b0551.patch?full_index=1"
    sha256 "f90f5f13a95f1d086dbf98cd3da072d1754299987ee1734a6d62fcda2139b55d"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
