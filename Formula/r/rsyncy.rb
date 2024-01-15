class Rsyncy < Formula
  include Language::Python::Virtualenv

  desc "Status/progress bar for rsync"
  homepage "https://github.com/laktak/rsyncy"
  url "https://github.com/laktak/rsyncy/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "35b8998e5ff13edd5ea833fcb8b837013424d86c3110091028d3ca71cdd46bde"
  license "MIT"
  head "https://github.com/laktak/rsyncy.git", branch: "master"

  depends_on "python@3.12"
  depends_on "rsync"

  uses_from_macos "zlib"

  def install
    virtualenv_install_with_resources
  end

  test do
    # rsyncy is a wrapper, rsyncy --version will invoke it and show rsync output
    assert_match(/.*rsync.+version.*/, shell_output("#{bin}/rsyncy --version"))

    # test copy operation
    mkdir testpath/"a" do
      mkdir "foo"
      (testpath/"a/foo/one.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin/"rsyncy", "-r", testpath/"a/foo/", testpath/"a/bar/"
      assert_predicate testpath/"a/bar/one.txt", :exist?
    end
  end
end
