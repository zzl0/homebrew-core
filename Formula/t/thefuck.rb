class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programmatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/ac/d0/0c256afd3ba1d05882154d16aa0685018f21c60a6769a496558da7d9d8f1/thefuck-3.32.tar.gz"
  sha256 "976740b9aa536726fa23cadc9a10bf457e92e335901c61fcff9152c84485ac3d"
  license "MIT"
  head "https://github.com/nvbn/thefuck.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "088b22d1fce236f7a2d8c37ae19dd05bcfdb669a441b117c28e865c7cb946cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0de3ebd0766c538d124f74270a91730c8e3e083656e61f09b6e3edb837caf0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c20013e623b39c5bca1fd71e44b200f7e31a2d7f5a377bc92b4593f806aff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d94b1731b44013b526e005137ce28d06484966c41b99e20003d5d40fbbc753a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "146518f2b0e6653764c2a64b37fb19fc24293a1f28865f9fd19727237817be39"
    sha256 cellar: :any_skip_relocation, ventura:        "27254159fefb93d553c8f2941396061950c946354350bbac1d98396fb5771ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8a42c8a3f407106e49da365beaa4f03337e025907bcb69812d28cf1c66850e"
    sha256 cellar: :any_skip_relocation, big_sur:        "788c8f21aec08c8df7cf09ca2be2b5069657af6e9dd1476b7d3b675451549976"
    sha256 cellar: :any_skip_relocation, catalina:       "125e506e6b470358180f6fe49cb45aa99617442a1649fb7a9db18c8aafbd0c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa50d5f202ecb6c751b1f8da9c2e943992bfc182bb6dfaa8b4ffdb46514e0225"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2d/01/beb7331fc6c8d1c49dd051e3611379bfe379e915c808e1301506027fce9d/psutil-5.9.6.tar.gz"
    sha256 "e4b92ddcd7dd4cdd3f900180ea1e104932c7bce234fb88976e2a3b296441225a"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/ab/ab/b599762933eba04de7dc5b31ae083112a6c9a9db15b01d3109ad797559d9/pyte-0.8.2.tar.gz"
    sha256 "5af970e843fa96a97149d64e170c984721f20e52227a2f57f0a54207f08f083f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/1c/21f2379555bba50b54e5a965d9274602fe2bada4778343d5385840f7ac34/wcwidth-0.2.10.tar.gz"
    sha256 "390c7454101092a6a5e43baad8f83de615463af459201709556b6e4b1c861f97"
  end

  # Drop distutils for 3.12: https://github.com/nvbn/thefuck/pull/1404
  patch do
    url "https://github.com/nvbn/thefuck/commit/dd26fb91a0fdec42fc1990bb91eab21e2c44a0a8.patch?full_index=1"
    sha256 "ea7824d7e4947fb9cd81ed1b5850b53b0e071a82b7e77acaba2391a8bf161b85"
  end

  # Drop imp for 3.12: https://github.com/nvbn/thefuck/commit/0420442e778dd7bc53bdbdb50278eea2c207dc74
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Add the following to your .bash_profile, .bashrc or .zshrc:

        eval $(thefuck --alias)

      For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    ENV["THEFUCK_REQUIRE_CONFIRMATION"] = "false"
    ENV["LC_ALL"] = "en_US.UTF-8"

    output = shell_output("#{bin}/thefuck --version 2>&1")
    assert_match "The Fuck #{version} using Python", output

    output = shell_output("#{bin}/thefuck --alias")
    assert_match "TF_ALIAS=fuck", output

    output = shell_output("#{bin}/thefuck echho ok")
    assert_equal "echo ok", output.chomp

    output = shell_output("#{bin}/fuck")
    assert_match "Seems like fuck alias isn't configured!", output
  end
end

__END__
diff --git a/thefuck/conf.py b/thefuck/conf.py
index 27876ef47..611ec84b7 100644
--- a/thefuck/conf.py
+++ b/thefuck/conf.py
@@ -1,4 +1,3 @@
-from imp import load_source
 import os
 import sys
 from warnings import warn
@@ -6,6 +5,17 @@
 from . import const
 from .system import Path
 
+try:
+    import importlib.util
+
+    def load_source(name, pathname, _file=None):
+        module_spec = importlib.util.spec_from_file_location(name, pathname)
+        module = importlib.util.module_from_spec(module_spec)
+        module_spec.loader.exec_module(module)
+        return module
+except ImportError:
+    from imp import load_source
+
 
 class Settings(dict):
     def __getattr__(self, item):
diff --git a/thefuck/types.py b/thefuck/types.py
index 96e6ace67..b3b64c35d 100644
--- a/thefuck/types.py
+++ b/thefuck/types.py
@@ -1,9 +1,8 @@
-from imp import load_source
 import os
 import sys
 from . import logs
 from .shells import shell
-from .conf import settings
+from .conf import settings, load_source
 from .const import DEFAULT_PRIORITY, ALL_ENABLED
 from .exceptions import EmptyCommand
 from .utils import get_alias, format_raw_script
