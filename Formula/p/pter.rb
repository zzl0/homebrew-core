class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/86/10/3c9a8c8c69ce21665f232cd2e23717e8d77d6b7c2d5c8909e5b550997b41/pter-3.13.0.tar.gz"
  sha256 "874863b71c444b97850bff4b41b0aeaf81fa84a389ef15e00fb279da0c3e5d65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43abe511cdec6f5e91e82ec2005a91ccf9e0e2be3c9fad622bd288aa76c32bec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7a76138493bed1fed390c612644c2bb3b5f46144626a70a9f81643fb01b62d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0bb60401a6083a099057cc99cd2cf66a490aaf626003f768b24bd26153735b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cdb8afc583d113a479ee7518d7d34f91ff80c50311ff1829f534d77c8807315"
    sha256 cellar: :any_skip_relocation, ventura:        "f6cc90d3a759924a87279653e3af71fb78af1f2bac720846e7a8b49bf3f7585a"
    sha256 cellar: :any_skip_relocation, monterey:       "f14f7c1b0f170a3974f5bb375152d525953bdda591e8c83c1e435679e4fdb0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ff2a517c16367d798a10da7fb0e5953599c9e491e62ec01a9a88a1291f86dd9"
  end

  depends_on "python@3.12"

  resource "cursedspace" do
    url "https://files.pythonhosted.org/packages/cd/3b/72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93/cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https://files.pythonhosted.org/packages/51/18/a8f4d15eb31bcde441b0ec090c5d97c435beabc9620199e7f90d2f5ad1af/pytodotxt-1.5.0.tar.gz"
    sha256 "99be359438c52e0c4fc007e11a89f5a03af00fc6851a6ba7070dfe0e00189009"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    PTY.spawn(bin/"pter", "todo.txt") do |r, w, _pid|
      w.write "n"         # Create new task
      w.write "some task" # Task description
      w.write "\r"        # Confirm
      w.write "q"         # Quit
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "some task", (testpath/"todo.txt").read
  end
end
