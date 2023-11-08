# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.wp.mines-telecom.fr/"
  url "https://github.com/gpac/gpac/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "8173ecc4143631d7f2c59f77e1144b429ccadb8de0d53a4e254389fb5948d8b8"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a84de69ae0466a5dbd0ac4b72467f8c5b3c014f7f1dd28f7d0f92ebd0b9d5d08"
    sha256 cellar: :any,                 arm64_monterey: "726e848f614718e84bdb1334a728bef9a3223a2988796f375fcac990c2984752"
    sha256 cellar: :any,                 arm64_big_sur:  "6922542eff06034e5c339e3024d4dfe5b7777fe45b2974c8fc27933d8a53c3f1"
    sha256 cellar: :any,                 ventura:        "39aad91d3b061ddfcfea25275ec4424b1ef7587c96d4d5b983dbde3432648ab9"
    sha256 cellar: :any,                 monterey:       "2471afe10295b7c46c43f1d96cfb138ad0aafe151e434b15c429388ea996141f"
    sha256 cellar: :any,                 big_sur:        "0ef3b2c3a0fcb8b1d6c0b180a1115258464b9c6117f5c047b5aca776244301b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16457bcbb191b392f7511ccacfa7cdb83499bbdaff5b1bd34fa68d9f28737d16"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "bento4", because: "both install `mp42ts` binaries"

  # https://github.com/gpac/gpac/issues/2673
  patch do
    url "https://github.com/gpac/gpac/commit/ce2202796a1630129cdff42cc1c02c3a8ea7a75f.patch?full_index=1"
    sha256 "708ff80d95fcfd28720c6c56a9c32c76bb181911fa8f6cb9a0f38c8012e96e9d"
  end

  # https://github.com/gpac/gpac/issues/2406
  patch do
    url "https://github.com/gpac/gpac/commit/ba14e34dd7a3c4cef5a56962898e9f863dd4b4f3.patch?full_index=1"
    sha256 "22ea4f6e93ec457468759bf5599903bea5171b1216472d09967fc9c558fa9fb3"
  end

  def install
    args = %W[
      --disable-wx
      --disable-pulseaudio
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/MP4Box", "-add", test_fixtures("test.mp3"), "#{testpath}/out.mp4"
    assert_predicate testpath/"out.mp4", :exist?
  end
end
