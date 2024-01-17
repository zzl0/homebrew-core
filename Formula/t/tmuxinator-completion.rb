class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "5d5a2d0bcfc507f5a4518fe5f8077cb449040a504d0701cdde59b63f927adbfe"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  livecheck do
    formula "tmuxinator"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23173f7e32b442f4b4c001a6d7269b78cee13c875544c73d0bc76a37a70d81c8"
  end

  conflicts_with "tmuxinator", because: "the tmuxinator formula includes completion"

  def install
    bash_completion.install "completion/tmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completion/tmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion/*.fish"]
  end

  test do
    assert_match "-F _tmuxinator",
      shell_output("bash -c 'source #{bash_completion}/tmuxinator && complete -p tmuxinator'")
  end
end
