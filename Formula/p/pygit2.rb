class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/82/08/77f77ec32b6d1363082be00c572f970d2a6200abf42df6d6ca86b8cd30e3/pygit2-1.13.0.tar.gz"
  sha256 "6dde37436fab14264ad3d6cbc5aae3fd555eb9a9680a7bfdd6e564cd77b5e2b8"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22f0fa908d1b0c7fdd641870f91d43d92644d4faabba5290bc39ae31ae952fb7"
    sha256 cellar: :any,                 arm64_monterey: "de6a514750633ac304c0d49fc36301214dca7d0fd1fc092a8aaaec575f958409"
    sha256 cellar: :any,                 arm64_big_sur:  "4682bfadb61a9b2607ca9db9c6d361142b7c765d91f5245e6c322b12abe89bd3"
    sha256 cellar: :any,                 ventura:        "a79aa69152665012c3ac58143adfb9c03362c38106750a7e78c76d02ef41674b"
    sha256 cellar: :any,                 monterey:       "05ff09ea91d8e9bf286e276cb2e0ca9c57fc69289db4b98dd16c3fbae4d067af"
    sha256 cellar: :any,                 big_sur:        "951cff1fbdc544daeb39fe4ca20a76b6ecff665248bad7e170552e0a6461451c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a124bcb5a55ede4a35ab79e4e22fd3f2e48f3640cbf446beba101f214c650fbd"
  end

  depends_on "cffi"
  depends_on "libgit2"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"hello.txt").write "Hello, pygit2."
    system python3, "-c", <<~PYTHON
      import pygit2
      repo = pygit2.init_repository('#{testpath}', False) # git init

      index = repo.index
      index.add('hello.txt')
      index.write() # git add

      ref = 'HEAD'
      author = pygit2.Signature('BrewTestBot', 'testbot@brew.sh')
      message = 'Initial commit'
      tree = index.write_tree()
      repo.create_commit(ref, author, author, message, tree, []) # git commit
    PYTHON

    system "git", "status"
    assert_match "hello.txt", shell_output("git ls-tree --name-only HEAD")
  end
end
