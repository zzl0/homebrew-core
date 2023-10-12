class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.35.1/php-cs-fixer.phar"
  sha256 "b36d2d55b4786f2c1362827515f7387445a4709bd798a2d8445d58bfc5aeea9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcb9e5ac56743ca4c2c578f5035d96d9ff6f22ff7e8b6d38d5d48617fd552a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcb9e5ac56743ca4c2c578f5035d96d9ff6f22ff7e8b6d38d5d48617fd552a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcb9e5ac56743ca4c2c578f5035d96d9ff6f22ff7e8b6d38d5d48617fd552a70"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcb9e5ac56743ca4c2c578f5035d96d9ff6f22ff7e8b6d38d5d48617fd552a70"
    sha256 cellar: :any_skip_relocation, ventura:        "bcb9e5ac56743ca4c2c578f5035d96d9ff6f22ff7e8b6d38d5d48617fd552a70"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb9e5ac56743ca4c2c578f5035d96d9ff6f22ff7e8b6d38d5d48617fd552a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9f915f997f79f7800b74e427136e854bdb655641a3fbc47bc39bc456fbcf76"
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
