class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/b8/a0/524e0aaabf9bc3dfcfb4da4c61a0469d5cbac31e39dd807a832ea6098c91/argcomplete-3.2.1.tar.gz"
  sha256 "437f67fb9b058da5a090df505ef9be0297c4883993f3f56cb186ff087778cfb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "724ea744fb1a4d0b4accf952f10edc899fdeb04688ca66c9943832c0b8dd984d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e937cebbeac8c71ecfaeb04b22fa7315f81ec2804d7e905ba6c3652b8801905f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6980e0cfda73eb6c8b95d07674094c0c3afb1cfb247e27b13a8b7feed3212b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "516bdf28ffaf8f94d42fd76b7b01f6e4e2fbacab16b45081b2d4f1f26b18bd16"
    sha256 cellar: :any_skip_relocation, ventura:        "006131a468398b0025dc0d2b1541f2e9b42f2540abb49acb88bd6d06a2d53203"
    sha256 cellar: :any_skip_relocation, monterey:       "59728d504c6fe9df1344ff9130d429bc5850f5543ac3416647d99530bca1a15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69784bba7a357f973eb50f42ec7dfef49e89790384c355c40b9020783bc8891"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
