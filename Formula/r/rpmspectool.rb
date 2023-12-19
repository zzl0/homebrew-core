class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/c3/c9/4dab0dec09b4b5596ad5e3d4d0e4281d6a1bf3e3f24035c07fbdbaa158b9/rpmspectool-1.99.8.tar.gz"
  sha256 "4b973d523e6748e978e887d09ea201985d3806895e1c3456fc5a42455c1102b8"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de69f344a9e18ef3568b4bfb1537caaf775312d24e9519dac70734e2b7e47db7"
  end

  depends_on :linux
  depends_on "python-pycurl"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "rpm"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/85/b9/e2bef848f79fce1e70d048b4de873424fde918c54ac2e6b8638cca887243/argcomplete-2.1.2.tar.gz"
    sha256 "fc82ef070c607b1559b5c720529d63b54d9dcf2dcfc2632b10e6372314a34457"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)/rpmbuild
      %_tmppath %_topdir/tmp
    EOS

    (testpath/"hello.spec").write <<~EOS
      Name:           hello
      Version:        2.12.1
      Release:        1
      Summary:        Prints a familiar, friendly greeting
      License:        GPL-3.0-or-later AND GFDL-1.3-or-later
      URL:            https://www.gnu.org/software/hello/
      Source0:        https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz

      %description
      The GNU Hello program produces a familiar, friendly greeting.
      Yes, this is another implementation of the classic program that
      prints “Hello, world!” when you run it.

      %prep
      %setup -q

      %build
      %configure
      %make_build

      %install
      %make_install
      rm -f $RPM_BUILD_ROOT/%_infodir/dir
      %find_lang hello

      %files -f hello.lang
      %license COPYING
      %_mandir/man1/hello.1*
      %_bindir/hello
      %_infodir/hello.info*
    EOS
    system bin/"rpmspectool", "get", testpath/"hello.spec"
    assert_predicate testpath/"hello-2.12.1.tar.gz", :exist?
  end
end
