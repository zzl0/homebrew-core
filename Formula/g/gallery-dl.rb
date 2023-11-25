class GalleryDl < Formula
  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/79/73/87d61facef7cc7e461ac7a3ca07dce0d8577f79032d3b7c783c18d612cb8/gallery_dl-1.26.2.tar.gz"
  sha256 "02071cb33d139730839e1479572ed3b778ebab3f7e87069c95081724184663dc"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c69d4d1b2c48daedc8e7e1a69d9b5a3a083b37b3c9217dfc81b920fe4703195"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3209431e2aaa13cd6d0837c1b509fab9cbcc8e33bd71a7976dc959dbc59f2307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633faea77590fc0cc58badf213655f61886a8d7579172fc282f5e54b8962bf5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a80339bba852d9a685e4cd87f845c310e3cf65751cebf99e81c6840d0b3dcc59"
    sha256 cellar: :any_skip_relocation, ventura:        "f801e755101b789632f58106e5675c1a309fcde42426fcac3fc5fde624f2f8aa"
    sha256 cellar: :any_skip_relocation, monterey:       "eb493f1c831229301f7777d8479b3cf531eb8fda64a6c5d97623ffafb43c7edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42afa425f85f957f78cbd9d4d4d831583032c6a0ff64e36173ef70fcbf15bea3"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
