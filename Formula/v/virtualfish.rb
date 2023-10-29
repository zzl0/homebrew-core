class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/2f/a7800ae09a689843b62b3eb423d01a90175be5795b66ac675f6f45349ca9/virtualfish-2.5.5.tar.gz"
  sha256 "6b654995f151af8fca62646d49a62b5bf646514250f1461df6d42147995a0db2"
  license "MIT"
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "869c8a12184ad98701a95942837e86ba30a8651f84f482f15c8d49ff6f42732e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "283a6425d3bd1d9ca8b2d212923b854683abf4137513d3e31d63fdd8739d52ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dcedf8f5e261b6f571dd62f9cb3cce49446dce451eeaaffb0918982815671f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9973b9fb1e8178283ab5fc0424f28deaaa7130cfd7edcf90ed2e2adf59ddc07a"
    sha256 cellar: :any_skip_relocation, ventura:        "709e6684df5d34e84e37508e8f3640ce8818db3c726b14fa3d1ab142d672e354"
    sha256 cellar: :any_skip_relocation, monterey:       "2d18040a59d0c4d2279a1cf6d2d1cc5e98067a143854b3b196b287d8bb80e705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ceff02ecc7db355983c71e51f6dd4ca74129bfd8c19d5961021162c9611200e"
  end

  depends_on "fish"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  def caveats
    <<~EOS
      To activate virtualfish, run the following in a fish shell:
        vf install
    EOS
  end

  test do
    # Pre-create .virtualenvs to avoid interactive prompt
    (testpath/".virtualenvs").mkpath

    # Run `vf install` in the test environment, adds vf as function
    refute_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"
    assert_match "VirtualFish is now installed!", shell_output("fish -c '#{bin}/vf install'")
    assert_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"

    # Add virtualenv to prompt so virtualfish doesn't link to prompt doc
    (testpath/".config/fish/functions/fish_prompt.fish").write(<<~EOS)
      function fish_prompt --description 'Test prompt for virtualfish'
        echo -n -s (pwd) 'VIRTUAL_ENV=' (basename "$VIRTUAL_ENV") '>'
      end
    EOS

    # Create a virtualenv 'new_virtualenv'
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
    system "fish", "-c", "vf new new_virtualenv"
    assert_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"

    # The virtualenv is listed
    assert_match "new_virtualenv", shell_output('fish -c "vf ls"')

    # Delete the virtualenv
    system "fish", "-c", "vf rm new_virtualenv"
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
  end
end
