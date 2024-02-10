class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/a6/56/29006be2546b897a5c62a3d4a7e613abf5a3533554d948b0e0af27546f1b/all_repos-1.27.0.tar.gz"
  sha256 "96fea3e34caa004b0770501e6efb93dc49cbca05fb56c2b8b2a85d06fb3a4573"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2abb8c0300b10d3b79d2b69a8ebfa5eef6fc4cfa445d7652093823a7866da7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b87c3ba274ee120a76bd94dc0ce8f0b75d98b41cc5b2d8109115dd1b74d71e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63fea1918cfb61ce7cfc22b9de52f7e3f59852a35ffbc51104ead621c59c4e8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ccde45a0c3d87518925cd85e01694ed132743134d371a3f860a1cd50dbb7d23"
    sha256 cellar: :any_skip_relocation, ventura:        "a1806a3ee959d9c50e978cc9bfc34ce75f532a4d8b823a0239b99f47373026e7"
    sha256 cellar: :any_skip_relocation, monterey:       "e2ca72e0c967bd81375d267b93f6cd1e7681960cad3daec2c33b869b0259841a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c329e848be1382ce9c4848c5e6c1b1045058d123d5eb8e7c765705ad65836db2"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/61/a0/92aba7e128faadab9db785c1f8cc442caf51cba5a55b575abb211b12526f/identify-2.5.33.tar.gz"
    sha256 "161558f9fe4559e1557e1bff323e8631f6a0e4837f7497767c1782832f16b62d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~EOS
      {"discussions": "https://github.com/Homebrew/discussions"}
    EOS

    system bin/"all-repos-clone"
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
