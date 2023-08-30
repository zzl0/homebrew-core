class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.24.0/php-cs-fixer.phar"
  sha256 "082015ee6c3911a71d864699d75169d8f2d705fb3b34cccf1b1d54891d4e2906"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02ae322a91bff79e49c40eed55848de209b054eae71bf6717741ed9503e416d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02ae322a91bff79e49c40eed55848de209b054eae71bf6717741ed9503e416d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02ae322a91bff79e49c40eed55848de209b054eae71bf6717741ed9503e416d6"
    sha256 cellar: :any_skip_relocation, ventura:        "02ae322a91bff79e49c40eed55848de209b054eae71bf6717741ed9503e416d6"
    sha256 cellar: :any_skip_relocation, monterey:       "02ae322a91bff79e49c40eed55848de209b054eae71bf6717741ed9503e416d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "02ae322a91bff79e49c40eed55848de209b054eae71bf6717741ed9503e416d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9a7c0007a1cb3f6c22cbda54dad25ad8515f8baa13b53036728aac8e490d01"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
