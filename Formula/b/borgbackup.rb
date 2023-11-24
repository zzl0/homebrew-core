class Borgbackup < Formula
  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/cd/a2/d4375923a8b858312e6f4593ac7f613d338394f3feb669f67d2a6269d2f9/borgbackup-1.2.6.tar.gz"
  sha256 "b7a6f8f086039eeec79070b914f3c651ed7f3612c965374af910d277c7a2139d"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "20a868b4940aadeee8d547c9fdd95f325018623210d78a30f1f5bc6eae6e3107"
    sha256 cellar: :any,                 arm64_ventura:  "67ca0c5c3362efb43117076d3d67710366c81b3745a0f64e71899b500c238f93"
    sha256 cellar: :any,                 arm64_monterey: "06e511759cf40e0cb49978bb58c3cab396d154a3ac54bcff2acb88ef07c00419"
    sha256 cellar: :any,                 sonoma:         "fb9bba97a8a5079ab107ffcc661214c58e5eb128a138027889907b09b6785926"
    sha256 cellar: :any,                 ventura:        "0eda44bdae832aeb4fc23b46b434b5203a71e4587834e5a9d73e43c826d113db"
    sha256 cellar: :any,                 monterey:       "cf81ce62690aa07d663dbafe2e9d96471a05d8e755686671deca79714474e3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5f9e4355ae28ad3645d4653a3097281ffb764b2b227ec9eb63c1abfed71f47"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python-msgpack"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  def python3
    "python3.12"
  end

  # master build already support 1.0.7 without much change
  # new release requst issue, https://github.com/borgbackup/borg/issues/7948
  patch :DATA

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@3"].prefix

    system python3, "-m", "pip", "install", *std_pip_args, "."

    man1.install Dir["docs/man/*.1"]
    bash_completion.install "scripts/shell_completions/bash/borg"
    fish_completion.install "scripts/shell_completions/fish/borg.fish"
    zsh_completion.install "scripts/shell_completions/zsh/_borg"
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath
    Dir.chdir(testpath) do
      system "#{bin}/borg", "init", "-e", "none", "test-repo"
      system "#{bin}/borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system "#{bin}/borg", "extract", testpath/"test-repo::test-archive"
    end
    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end

__END__
diff --git a/src/borg/helpers/msgpack.py b/src/borg/helpers/msgpack.py
index 309c988..197d2de 100644
--- a/src/borg/helpers/msgpack.py
+++ b/src/borg/helpers/msgpack.py
@@ -182,7 +182,7 @@ def is_slow_msgpack():
 def is_supported_msgpack():
     # DO NOT CHANGE OR REMOVE! See also requirements and comments in setup.py.
     import msgpack
-    return (0, 5, 6) <= msgpack.version <= (1, 0, 5) and \
+    return (0, 5, 6) <= msgpack.version <= (1, 0, 7) and \
            msgpack.version not in [(1, 0, 1), ]  # < add bad releases here to deny list
 
 
