class Phpbrew < Formula
  desc "Brew & manage PHP versions in pure PHP at HOME"
  homepage "https://phpbrew.github.io/phpbrew"
  url "https://github.com/phpbrew/phpbrew/releases/download/2.2.0/phpbrew.phar"
  sha256 "3247b8438888827d068542b2891392e3beffebe122f4955251fa4f9efa0da03d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53bc9521ba4a293a2e667bca5270760ed90af2bb83908d5fd5940a8dd5f7f443"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53bc9521ba4a293a2e667bca5270760ed90af2bb83908d5fd5940a8dd5f7f443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53bc9521ba4a293a2e667bca5270760ed90af2bb83908d5fd5940a8dd5f7f443"
    sha256 cellar: :any_skip_relocation, sonoma:         "524a21b9ca0896816a411948857b6d98d32d01e522a947bdfcb915ada945770a"
    sha256 cellar: :any_skip_relocation, ventura:        "524a21b9ca0896816a411948857b6d98d32d01e522a947bdfcb915ada945770a"
    sha256 cellar: :any_skip_relocation, monterey:       "524a21b9ca0896816a411948857b6d98d32d01e522a947bdfcb915ada945770a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53bc9521ba4a293a2e667bca5270760ed90af2bb83908d5fd5940a8dd5f7f443"
  end

  # TODO: When `php` 8.2+ support is landed, switch back to `php`.
  # https://github.com/phpbrew/phpbrew/blob/#{version}/composer.json#L27
  depends_on "php@8.1"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    # When switched back to `php`, use `bin.install` instead.
    # bin.install "phpbrew.phar" => "phpbrew"

    libexec.install "phpbrew.phar"
    (bin/"phpbrew").write <<~EOS
      #!#{Formula["php@8.1"].opt_bin}/php
      <?php require '#{libexec}/phpbrew.phar';
    EOS
  end

  test do
    system bin/"phpbrew", "init"
    assert_match "8.0", shell_output("#{bin}/phpbrew known")
  end
end
