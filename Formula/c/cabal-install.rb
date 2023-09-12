class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.10"

  stable do
    url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0.tar.gz"
    sha256 "995de368555449230e0762b259377ed720798717f4dd26a4fa711e8e41c7838d"

    # Use Hackage metadata revision to support GHC 9.6.
    # TODO: Remove this resource on next release along with corresponding install logic
    resource "cabal-install.cabal" do
      url "https://hackage.haskell.org/package/cabal-install-3.10.1.0/revision/1.cabal"
      sha256 "7668e8dcd3612d8520e16f420c973cd5ceeddb8237422e800067d6c367523940"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40ab69cd21f54e597795b71abf344665072feb6ac2b03bd2bae0e04bb631ef83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af91ef28d8d82761de341be8277b8ab61c50c9c222d27ff1f6265ec11595be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "252fe73c7aaf9c44ef3a2f7dc25bc89230a614591dcd6efcf1a8ccc8bec901ac"
    sha256 cellar: :any_skip_relocation, ventura:        "c1d60e3d027bdef6559d3128c4139bc1d93a73cc3e60323c4a135eb948962c76"
    sha256 cellar: :any_skip_relocation, monterey:       "a682772e0cf626c821efd4d884737e33104831d1e5ab2ce6f90be557aa872ca6"
    sha256 cellar: :any_skip_relocation, big_sur:        "395c7c55426e70ecadbcfd943d9b4e0a4cd8799331a2f0b585289bd0a93f8c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d84d35b0bd0a269423bb92082e848227f24c3fe61549da35b42da32c46effae"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-aarch64-darwin.tar.xz"
        sha256 "fdabdc4dca42688a97f2b837165af42fcfd4c111d42ddb0d4df7bbebd5c8750e"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-x86_64-darwin.tar.xz"
        sha256 "893a316bd634cbcd08861306efdee86f66ec634f9562a8c59dc616f7e2e14ffa"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-x86_64-linux-ubuntu20_04.tar.xz"
      sha256 "b0752c4c5e53eec56af23a1e7cd5a18b5fc62dd18988962aa0aa8748a22af52d"
    end
  end

  def install
    resource("cabal-install.cabal").stage { buildpath.install "1.cabal" => "cabal-install.cabal" } unless build.head?
    resource("bootstrap").stage buildpath
    cabal = buildpath/"cabal"
    cd "cabal-install" if build.head?
    system cabal, "v2-update"
    system cabal, "v2-install", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system bin/"cabal", "--config-file=#{testpath}/config", "user-config", "init"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
