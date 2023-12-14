class RubyCompletion < Formula
  desc "Bash completion for Ruby"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ee8b84d7ac7444a7388e58a406af56dc0b690a57faa7bcfa4c10671deb788991"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "534da18dd29bafad68930a70b41d94de09a99d0c4cf01e62bdb1a3c3f49fd3f3"
  end

  def install
    bash_completion.install "completion-ruby" => "ruby"
  end

  test do
    assert_match "-F __ruby",
      shell_output("bash -c 'source #{bash_completion}/ruby && complete -p ruby'")
  end
end
