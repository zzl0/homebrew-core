class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.38.3/mk-configure-0.38.3.tar.gz"
  sha256 "c6b5dfdca304eb9462f7d61f94f591844ef2a1ea7c0bbe1397eeff9c9b912afa"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eec729078abdb84a501dfdcee135017b24ba7e292629005d37a9a55cb1b289b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ff8ccca0eb63cc9f2ab9245887caabe11a9ef50f47133a4c726a39d6ceb88c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03ff8ccca0eb63cc9f2ab9245887caabe11a9ef50f47133a4c726a39d6ceb88c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d45e9deae52d90c2fc31e44ead23819539b7f9837e3ad6958758978de8ee252"
    sha256 cellar: :any_skip_relocation, sonoma:         "75ff615cddc4854e22de5cd9910c8c9832e59e0db6df970c557000791e341335"
    sha256 cellar: :any_skip_relocation, ventura:        "ec1844ffc84ab220c5eeed4faf0deed8a1d7af581c300e07cc46afff88de6a8d"
    sha256 cellar: :any_skip_relocation, monterey:       "ec1844ffc84ab220c5eeed4faf0deed8a1d7af581c300e07cc46afff88de6a8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3013691ee8d1abba074ceee462089b99a3c6dbf149801595cf00f6d6c43983"
    sha256 cellar: :any_skip_relocation, catalina:       "e6d967eb5e56d1aeebe357d1bdba6872bb6eeed45e182c5a1ac0aa0e40248d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "344d246a3812813f1738f186a4b988c46c8e0f2a74430f68e4040cbd99b48c08"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
