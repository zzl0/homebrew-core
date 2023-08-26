class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.7.0/nuget.exe" # make sure libexec.install below matches case
  sha256 "1a98b29bcc3aea4ba8ca66d35523f8e90cb28e54588f9c13589c50af5d8623c9"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc7238fddb23eb45fe55703630fb0605c1b75f7ec100636e70e9f271b710cb82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc7238fddb23eb45fe55703630fb0605c1b75f7ec100636e70e9f271b710cb82"
    sha256 cellar: :any_skip_relocation, ventura:        "dc7238fddb23eb45fe55703630fb0605c1b75f7ec100636e70e9f271b710cb82"
    sha256 cellar: :any_skip_relocation, monterey:       "dc7238fddb23eb45fe55703630fb0605c1b75f7ec100636e70e9f271b710cb82"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc7238fddb23eb45fe55703630fb0605c1b75f7ec100636e70e9f271b710cb82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e12d1767a00632aacf3f7accee284e875a50282a0558e04a0e5b4ab09d73910"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
