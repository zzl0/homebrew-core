class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.54/phpstan.phar"
  sha256 "4c76016cf3a732b931656acbc1c89cf1a77b51dac3a6668eb94988921a5c14e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f19c9519797885b1787abb474aeb71c1e943c1b6850ee7aca94845c2b104209e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f19c9519797885b1787abb474aeb71c1e943c1b6850ee7aca94845c2b104209e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f19c9519797885b1787abb474aeb71c1e943c1b6850ee7aca94845c2b104209e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fd188e8ab1278bcff71a033e0e6937964779a1618241ddeb1d418cec4ee81f6"
    sha256 cellar: :any_skip_relocation, ventura:        "6fd188e8ab1278bcff71a033e0e6937964779a1618241ddeb1d418cec4ee81f6"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd188e8ab1278bcff71a033e0e6937964779a1618241ddeb1d418cec4ee81f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f19c9519797885b1787abb474aeb71c1e943c1b6850ee7aca94845c2b104209e"
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
