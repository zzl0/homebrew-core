class RailsCompletion < Formula
  desc "Bash completion for Rails"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ee8b84d7ac7444a7388e58a406af56dc0b690a57faa7bcfa4c10671deb788991"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e52f96f415b50192094012cd4678e96b1c5e119c133224d4302e0bf2f6acea0e"
  end

  def install
    bash_completion.install "completion-rails" => "rails"
  end

  test do
    assert_match "-F __rails",
      shell_output("bash -c 'source #{bash_completion}/rails && complete -p rails'")
  end
end
