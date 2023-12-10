class GalleryDl < Formula
  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/57/7d/d4eca5fd33ba5aeb30bb77a5928bb320c46d4f02ba4077481336c5c1475e/gallery_dl-1.26.4.tar.gz"
  sha256 "aa83561fb7e898e40474ecf4fac117b5f85722d3e87d231b0ef40298770e3d7a"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b48302b7a2240b7b2e79affd9c238257a916d5180a925b21b54429242596adf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c40abd22fe3bc06a7261b224c36a6ad2668210173d18609dab2a693547e35a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44286bb265ec8acedd87977debd6d0618699043aa51f3fb8f6ebd7c443d9846b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f12840dc45084b446b3c8b5ea2baac6573162ce9e064e8f7eaee83f8bc65f8ee"
    sha256 cellar: :any_skip_relocation, ventura:        "0318c7fe0423299c629aa2c45855404bce2e0ecb33d65e003196d60fcb9907b6"
    sha256 cellar: :any_skip_relocation, monterey:       "dad0706be705c822ffd133c60b2acf0b25302c59e925fda54375d8763537d2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b9ce2e4f2dcab4e8c7eb1c77126f38fb2801390faaeedd172c065baffa72ad"
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
