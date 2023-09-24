class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/66/2d/14a4e2d2b0a5a03d781cc1603c07d9f89c36ae4e1ba22e74e084d3d08201/yt-dlp-2023.9.24.tar.gz"
  sha256 "cfcfb5ffc12013b6ae4b8c7a283a7e462988f1b49283de291de8bfbe053b8073"
  license "Unlicense"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b33d0b31fa33f6b40b673d619535371fca2a260d7b003033af30976f514ae90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bda3b7ff3e1a21cdf3a6ae8ee74c619b1ded8eaf3c4c8bc27be8eadbcd53c61a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f4915e7a93536ce47a22aeb142a4e6e6bd8b65c59f6a8187c54519ad254222e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21f6d0153bd80dfab8b3bccd9a01479c7fa7e5a572f287b680fedc839afafbe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2df66b14e9defcb1bf18a9a594e6c2743de3dfc05589fc7ef54e915cba2f406d"
    sha256 cellar: :any_skip_relocation, ventura:        "50b4977a36a1bbe35376c8ff63a0938ef095175dd55033adf8a451a75b80d955"
    sha256 cellar: :any_skip_relocation, monterey:       "4242b28e5152b7e5cc8179852ea1420eb107136b6dabc56af9064f87f2a15244"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5a93f0baaac1a92fb552c5d2b5034019e9383596b2566086b4f8857686c9e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d02969e3d2453c145014e841d80e3da3003d109ee0828d0010fca27dda643c"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python-certifi"
  depends_on "python-mutagen"
  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/c9/09d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53/pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  def install
    system "make", "pypi-files" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
