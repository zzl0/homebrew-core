class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.29.0/php-cs-fixer.phar"
  sha256 "d1abb2793ac7b3874c04826a3ed8e6d1ff8778979a05d897f069d0d07fa1b588"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, sonoma:         "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, ventura:        "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, monterey:       "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, big_sur:        "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad2beaac222bb040de449f295a8056c4d411fedc37f9779e7f9887a7a43417b"
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
