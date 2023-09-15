class ZshLovers < Formula
  desc "Tips, tricks, and examples for zsh"
  homepage "https://grml.org/zsh/#zshlovers"
  url "https://deb.grml.org/pool/main/z/zsh-lovers/zsh-lovers_0.10.1_all.deb"
  sha256 "b2cebc38bded607b77fa2738fe6ed7a770550b06e4ce7cbe6243701d0400c09c"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.grml.org/pool/main/z/zsh-lovers/"
    regex(/href=.*?zsh-lovers[._-]v?(\d+(?:\.\d+)+)[._-]all/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9a640ed5452e086874d853453e15cbd2e347a5a86d867db12a5245980f6aa54"
  end

  uses_from_macos "xz" => :build

  def install
    system "ar", "x", "zsh-lovers_#{version}_all.deb"
    system "tar", "xf", "data.tar.xz"
    system "gunzip", *Dir["usr/**/*.gz"]
    prefix.install_metafiles "usr/share/doc/zsh-lovers"
    prefix.install "usr/share"
  end

  test do
    system "man", "zsh-lovers"
  end
end
