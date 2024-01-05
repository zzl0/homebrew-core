class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "83a80e9baf89045d3975a01b89ef679544d693a689f1798f05360ab0ca20df15"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee9f9e71d6b6ad08e1c00dffe5f411ed4c293246ab439a457cbece5ee2a3c192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ac6d09a3b2e2eb1e369f13d53b6daab1eeeeca7227f556324485e32a002824f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4ac85ef98ee19bcbc3173ba555486e23554e41a093cf8d9def3ab4d08d53d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1a1f42c2f229dc83cefd70b886c16e29a0f24fb5799bdd1cea766f95e491da1"
    sha256 cellar: :any_skip_relocation, ventura:        "9faa77cc11b8bbcf46a828b2bca83b31595c9d64e9c3fee7cb5a6e01d111ff0a"
    sha256 cellar: :any_skip_relocation, monterey:       "153a3cf9b8c57c9bbb1bd7195d3db285fc6f684f9c60b384bf5ccde9316ceb66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb02a7e3ab5ea5b1844a8872c47cfb07b804a54b2acea792b3917f8bef28221"
  end

  depends_on "emacs" => :build
  depends_on "erlang"

  # build patch for macos, upstream pr ref, https://github.com/lfe/lfe/pull/487
  patch do
    url "https://github.com/lfe/lfe/commit/7115d469e3239d7e7965db101e3e98675840a8f9.patch?full_index=1"
    sha256 "96e08c3517bc905f53a27e2678018a9f4d5d3297cb9c6e18a35b71777fdcbc8f"
  end

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc/*.txt")
    elisp.install Pathname.glob("emacs/*.elc")
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
