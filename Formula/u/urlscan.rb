class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/b7/7d/984994a32b261cc3a72d3bfb0b8c0de4f786682128dc659a5c5e02dfc48c/urlscan-1.0.1.tar.gz"
  sha256 "e0ec986e5aa2da57dd2face8692116d80af173d4eb56a78e4fd881731113307f"
  license "GPL-2.0-or-later"

  depends_on "python@3.12"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/58/7e/4191aa9a1c4a7b2f73a7548002754863189217464fbf76045526c7c97be5/urwid-2.4.1.tar.gz"
    sha256 "6207cfa8ac911f251bbebf4d454a00e622f68bd5cd2c9e55b53c6eac85bb4a6f"
  end

  def install
    virtualenv_install_with_resources

    man1.install "urlscan.1"
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
