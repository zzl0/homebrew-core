class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "442e70e4ab4e451b5316c178394fb2e54d1dbebabdc875be7c5a66965f370a12"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4486702cafa38389b24c6666f4b2113d521192da4b9af7d522ab63722ff45ab2"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
