class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.3.3/deployer.phar"
  sha256 "e85f68eeef818d7b09bf50946b006c0a096d23069e26875596e26310a6d06a76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e99a14e01b2aaca3b39223e67f9141339c0b068b3eb5ce7a5bec899903cbb4e3"
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
