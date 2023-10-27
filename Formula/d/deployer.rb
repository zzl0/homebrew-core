class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.3.2/deployer.phar"
  sha256 "ed2cd6b685c25e094c30b9cbfccb3b798459c05e4f7df924332a49d80dafbee7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d3a0df77b981e45f88dbd2feccf62a4a19178818dcd160c652a2cffec282d64"
  end

  depends_on "php"

  conflicts_with "dep", because: "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
