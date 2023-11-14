class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.38.2/php-cs-fixer.phar"
  sha256 "cb839aee98c0f8928a5449a921c3e70b5b3fea3f15cda5e8f736da32a6b99ddd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb85a6d3ea0edba5c4648a00cebef97d729f51591d7832b3dc7db7d1a48f8869"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb85a6d3ea0edba5c4648a00cebef97d729f51591d7832b3dc7db7d1a48f8869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb85a6d3ea0edba5c4648a00cebef97d729f51591d7832b3dc7db7d1a48f8869"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb85a6d3ea0edba5c4648a00cebef97d729f51591d7832b3dc7db7d1a48f8869"
    sha256 cellar: :any_skip_relocation, ventura:        "eb85a6d3ea0edba5c4648a00cebef97d729f51591d7832b3dc7db7d1a48f8869"
    sha256 cellar: :any_skip_relocation, monterey:       "eb85a6d3ea0edba5c4648a00cebef97d729f51591d7832b3dc7db7d1a48f8869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17e84ab8513a8520c329db6d62590d1548f4c6c16aa67166d57a9a2282e542c"
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
