class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://gitlab.com/akihe/radamsa"
  url "https://gitlab.com/akihe/radamsa/-/archive/v0.7/radamsa-v0.7.tar.gz"
  sha256 "d9a6981be276cd8dfc02a701829631c5a882451f32c202b73664068d56f622a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "327f8de9747d51e9ace1a62aaaf520f050687a1ec9a3b2c013b07046ba92747d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd11fada93d54e4f8f72ac47c20ea26e8298f64bc930a290e897ac671940b80d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d86d86fab9f28b1dd1b2a7b98fe0a224f1b5e059f58c978be4a0ea5a146083ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ee7ab43bc7155d05030cffef87111083e9d5b55b96d51c1ea54fc76fc9ce8fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "7189136ecfd1c1c609718e9813b00c7a3f6e981bad8977b026bf71ad28f7aa97"
    sha256 cellar: :any_skip_relocation, ventura:        "03cb4d8460f06c11572b3d5fe9862029081b8a5be996304702e8380d8ced58e6"
    sha256 cellar: :any_skip_relocation, monterey:       "68e110b46fd84cab81f57ce9d465e142e090067690f56808d11cbc31420b1eac"
    sha256 cellar: :any_skip_relocation, big_sur:        "925d63ed4fd304e24832bfff8acc6ae75d3549ad6f893292a4865ab7cd77c499"
    sha256 cellar: :any_skip_relocation, catalina:       "97fe42099e0b4278519ee560af5a38dd0cb5055e7542cd892d4c4f96d93960c5"
    sha256 cellar: :any_skip_relocation, mojave:         "a4d9d9e07ff76b8bb51333a04d645ea0213663dc635bdea890b1cffb7f2e6543"
    sha256 cellar: :any_skip_relocation, high_sierra:    "82d2231dcb25adb55f62690bd34d2b4b8978a3d22b956c0f0f2e20640d31c7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5a4c3e8c05fa322cea64074eb8ea2783d40d9394818aba84ea1f5845cec9cc1"
  end

  def install
    system "make", "future"
    man1.install "doc/radamsa.1"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      The Radamsa binary has been installed.
      The Lisp source code has been copied to:
        #{prefix}/rad

      Tests can be run with:
        $ make .seal-of-quality

    EOS
  end

  test do
    assert_match "Radamsa is a general purpose fuzzer.", shell_output("#{bin}/radamsa --about")
    assert_match "drop a byte", shell_output("#{bin}/radamsa --list")
    assert_match version.to_s, shell_output("#{bin}/radamsa --version")
  end
end
