class GemCompletion < Formula
  desc "Bash completion for gem"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ee8b84d7ac7444a7388e58a406af56dc0b690a57faa7bcfa4c10671deb788991"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "master"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "044d02a4211a0f89e550ff2f5779903cb443528f8f703ea2bd549bc39b9be595"
  end

  def install
    bash_completion.install "completion-gem" => "gem"
  end

  test do
    assert_match "-F __gem",
      shell_output("bash -c 'source #{bash_completion}/gem && complete -p gem'")
  end
end
