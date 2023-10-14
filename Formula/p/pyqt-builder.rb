class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/21/e9/5ee4d76d3f4c566b090924e36da067748db948a5faeff4142d149a4d5a15/PyQt-builder-1.15.3.tar.gz"
  sha256 "5b33e99edcb77d4a63a38605f4457a04cff4e254c771ed529ebc9589906ccdb1"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba7beb7965ff432174084feef946b626188608dbac80e80964c8cb488b53978d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7230d3b7df9b43b8f3a12716db58f0cb3b5a550548617bb3b403c416b37be3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab7230d3b7df9b43b8f3a12716db58f0cb3b5a550548617bb3b403c416b37be3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab7230d3b7df9b43b8f3a12716db58f0cb3b5a550548617bb3b403c416b37be3"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd19143846f1e0bfc9790662cb3235c8f22bf15ce47c7a01f12c5e03bc8cd08a"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7230d3b7df9b43b8f3a12716db58f0cb3b5a550548617bb3b403c416b37be3"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7230d3b7df9b43b8f3a12716db58f0cb3b5a550548617bb3b403c416b37be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab7230d3b7df9b43b8f3a12716db58f0cb3b5a550548617bb3b403c416b37be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbef68c7e68dbefe9ae0fad92ecd31488ceb64077e7aee1a67426a5afc91a83e"
  end

  depends_on "python@3.11"
  depends_on "sip"

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end
