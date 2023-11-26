class Grokmirror < Formula
  desc "Framework to smartly mirror git repositories"
  homepage "https://github.com/mricon/grokmirror"
  url "https://files.pythonhosted.org/packages/b0/ef/ffad6177d84dafb7403ccaca2fef735745d5d43200167896a2068422ae89/grokmirror-2.0.11.tar.gz"
  sha256 "6bc1310dc9a0e97836201e6bb14ecbbee332b0f812b9ff345a8386cb267c908c"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/mricon/grokmirror.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48ffb915382d3c3c0106297150c98641e1a4950d1d0434f44d1c2ca3c73621ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4317eae2de8cc4a9a63de1b12d3b4cb23f3443079e0a7aef3359b88ad1977b42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd91098fce6e1e55f476cfaa6098502d52c0b15d01a41fad00918a135ce3ff97"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7cfce7a604cc78690787ce214f120bbf9459eebaa9e8e1d2aa2be6e0cdfc89f"
    sha256 cellar: :any_skip_relocation, ventura:        "87c82e77728008740271848946b169ca9d777d12ece44afd508b65e130210843"
    sha256 cellar: :any_skip_relocation, monterey:       "927bc8d83aa022183e54e0257fd2beffa15c424c4d8388e2a6412ca8fbe06e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09139e279313c6e3c3a0fca1d7984cb8e676695f6d5e2caafb80b0d01a991846"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    mkdir "repos/repo" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
      (testpath/"repos/repo/test").write "foo"
      system "git", "add", "test"
      system "git", "commit", "-m", "Initial commit"
      system "git", "config", "--bool", "core.bare", "true"
      mv testpath/"repos/repo/.git", testpath/"repos/repo.git"
    end
    rm_rf testpath/"repos/repo"

    system bin/"grok-manifest", "-m", testpath/"manifest.js.gz", "-t", testpath/"repos"
    system "gzip", "-d", testpath/"manifest.js.gz"
    refs = Utils.safe_popen_read("git", "--git-dir", testpath/"repos/repo.git", "show-ref")
    manifest = JSON.parse (testpath/"manifest.js").read
    assert_equal Digest::SHA1.hexdigest(refs), manifest["/repo.git"]["fingerprint"]
  end
end
