class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.3/Natural_Docs_2.3.zip"
  mirror "https://naturaldocs.org/download/natural_docs/2.3/Natural_Docs_2.3.zip"
  sha256 "37dcfeaa0aee2a3622adc85882edacfb911c2e713dba6592cbee6812deddd2f2"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any, all: "567b95832d650915a5e845129d79a4cfdc0f0cab20870fad118425fd048e69db"
  end

  depends_on "mono"

  def install
    rm_f "libNaturalDocs.Engine.SQLite.Mac32.so"

    os = OS.mac? ? "Mac" : "Linux"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    libexec.install Dir["*"]
    (bin/"naturaldocs").write <<~EOS
      #!/bin/bash
      mono #{libexec}/NaturalDocs.exe "$@"
    EOS

    libexec.install_symlink etc/"naturaldocs" => "config"

    libexec.glob("libSQLite.*").each do |f|
      rm f if f.basename.to_s != "libSQLite.#{os}.#{arch}"
    end
  end

  test do
    system "#{bin}/naturaldocs", "-h"
  end
end
