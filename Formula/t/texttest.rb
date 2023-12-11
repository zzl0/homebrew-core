class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/7b/14/e52c96906f1d397c776c4940f68e9b44cae6b1a1aaba915c372638c3b48f/TextTest-4.3.1.tar.gz"
  sha256 "8c228914dbedbea291c3867c844bf32487306ada2a2cb2e3b228427da37bc7cb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ac65b78ffbda96051f7ef01afc307eaafced2bd290fcb70d84e89ba07397406"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e10a6420ea6e6fc53c1bb499d0f94550c7acc77407ab67d3b74eac7f4961861a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8fb5a98453edae0db4b2a175b5a7dd47f7a429a88b725835c0a0145158b3945"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab54ed9f3764c2733c4bfebcd3575b0f627568c1c772407a39cb98a64f1773b8"
    sha256 cellar: :any_skip_relocation, ventura:        "13a2039dff6eba8bb0eb8c8be0ead4949cc7c976df99fb71b6ed53a30fe11388"
    sha256 cellar: :any_skip_relocation, monterey:       "ac74fc81df8021f736223d96f464f9a7959fa0825f7fe8cf0abe5003f91e1fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "468a696b7a676bbafbd479e23dbc14ce6a9e829ec21c746a751999b1425002f9"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python-psutil"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
