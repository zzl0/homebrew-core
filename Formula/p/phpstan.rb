class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.32/phpstan.phar"
  sha256 "e71bde77556184a366b3b9e2ce11fe733eefb42ac14e460c011e1fa763e50d09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeee409107c76209ca21205390aefd7031c96d722510baa391cb9378322d8f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeee409107c76209ca21205390aefd7031c96d722510baa391cb9378322d8f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeee409107c76209ca21205390aefd7031c96d722510baa391cb9378322d8f19"
    sha256 cellar: :any_skip_relocation, ventura:        "5cc337b7aedb2d70f49172bcbf2362ff0cdb5b98372c88e29895bd66e7cb5904"
    sha256 cellar: :any_skip_relocation, monterey:       "5cc337b7aedb2d70f49172bcbf2362ff0cdb5b98372c88e29895bd66e7cb5904"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cc337b7aedb2d70f49172bcbf2362ff0cdb5b98372c88e29895bd66e7cb5904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeee409107c76209ca21205390aefd7031c96d722510baa391cb9378322d8f19"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
