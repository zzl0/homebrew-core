class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  # TODO: Try removing --constraint in next release of `cabal-install` or `ghc`.
  # GHC 9.8.1 includes Cabal 3.10.2.0 which has an issue building Objective-C sources.
  # Issue ref: https://github.com/haskell/cabal/issues/9190
  url "https://hackage.haskell.org/package/cabal-install-3.10.2.1/cabal-install-3.10.2.1.tar.gz"
  sha256 "d53620c5f72d40d7f225af03f9fe5d7dc4dc1e5b4e5297bace968970859f8244"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.10"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a13e9e35906f7bebfe3eed6ed30eeb6eef33c214150ad9e962cb533bedcb61d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d971441087454c80f4496d42b9ce15517e54975f73dc4d1417935db7f0f8bbc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf1653dbd912c65d6028abf2a2f21a589e34b5a37eea0f8557406748421f7e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f593288503f68e9a7d0b0c9869fb0a4cf9014dd63c042fdf6cf8661534a9c78"
    sha256 cellar: :any_skip_relocation, ventura:        "a985d2fddefd0bb9683351f1833f92a9ec4c196cdde0b92d182246e901ed3417"
    sha256 cellar: :any_skip_relocation, monterey:       "b3eea63092feeb5ee050ec741b2cc3a6adfac9ad1a179b1735727573a5dc9a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc550f7b66551aaf9b25b32f10d26a602af44d8699df9475760a96260c7b522"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-aarch64-darwin.tar.xz"
        sha256 "d2bd336d7397cf4b76f3bb0d80dea24ca0fa047903e39c8305b136e855269d7b"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-darwin.tar.xz"
        sha256 "cd64f2a8f476d0f320945105303c982448ca1379ff54b8625b79fb982b551d90"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-aarch64-linux-deb11.tar.xz"
        sha256 "daa767a1b844fbc2bfa0cc14b7ba67f29543e72dd630f144c6db5a34c0d22eb1"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "c2a8048caa3dbfe021d0212804f7f2faad4df1154f1ff52bd2f3c68c1d445fe1"
      end
    end
  end

  def install
    resource("bootstrap").stage buildpath
    cabal = buildpath/"cabal"
    cd "cabal-install" if build.head?
    system cabal, "v2-update"
    system cabal, "v2-install", "--constraint=Cabal>=3.10.2.1", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system bin/"cabal", "--config-file=#{testpath}/config", "user-config", "init"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
