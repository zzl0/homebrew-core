class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/ac/6a/6122e5f9a08f8b195cbc9d89e153e27e6a068e44de4a7e6494754a15e028/rdiff-backup-2.4.0.tar.gz"
  sha256 "1721ab8ae1f1e163117d776d52daf2ee53cb9b7e96ec749ee2bd5572ccf55935"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "78b53d1f43f5e464b8aff937338bf71bb52b364a1ac0130caccd53b08998a365"
    sha256 cellar: :any,                 arm64_ventura:  "a1a6059b860c19580ee73dd95380bd38f94d6b400bb172bab07b42da6650307f"
    sha256 cellar: :any,                 arm64_monterey: "985a81f2183cac7d2a8d016d9c990f61801b320f27df21c0eb5a3f068068434a"
    sha256 cellar: :any,                 arm64_big_sur:  "42cb546126b06033e25040430acd50360b623ce474fc3b35fca697b91294c415"
    sha256 cellar: :any,                 sonoma:         "26f2e5e0407cc1db21a68cd10bb5aacb0d6d5ad6f4d779ad2740aafb0e503e33"
    sha256 cellar: :any,                 ventura:        "d43a0aca5449acf0abf915b4cfae232329999fd49d0ed4a15d9cf58b9972591f"
    sha256 cellar: :any,                 monterey:       "172de9fcd3da2877e2b0718647d30f3df5f64a13c2327c235b6db289ba9de5bc"
    sha256 cellar: :any,                 big_sur:        "a9406a53d7ac5fe450d34c9b75c6cf974de62268b96c1cf2f8d4cc975848dbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaae5a0df1be561eafe424de6ba531a0a6d044f82789caecacc33ae125602643"
  end

  depends_on "librsync"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    python3 = "python3.11"
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
