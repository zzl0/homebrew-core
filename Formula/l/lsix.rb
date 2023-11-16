class Lsix < Formula
  desc "Shows thumbnails in terminal using sixel graphics"
  homepage "https://github.com/hackerb9/lsix"
  url "https://github.com/hackerb9/lsix/archive/refs/tags/1.8.2.tar.gz"
  sha256 "79bf81bd66747a9fab1692c52dcda004fe500fbae118dc0a6bdbc6d6aefa20c1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e04dc6de7545a6d9f6905dd19e9aeba8b141710fdea1e74818bdbc55cd0560ac"
  end

  depends_on "bash"
  depends_on "imagemagick"

  def install
    bin.install "lsix"
  end

  test do
    output = shell_output "#{bin}/lsix 2>&1"
    assert_match "Error: Your terminal does not report having sixel graphics support.", output
  end
end
