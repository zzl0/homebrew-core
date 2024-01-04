class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  # pull from git tag as gemspec uses `git ls-files`
  # For versions following v7.1.0, may be able to remove 4cac18e5 patch.
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v7.1.0",
      revision: "81092404aeaf1cb39dbf2551f50f007ed049c26c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ef656bf28c2086f747658798a989432e14c90e58c01c15bf792b1a5b5b711e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "164e134801f7eccba5c5cc70d98657dccdc5cf935a9fd92934e74d6c0ffce0e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "164e134801f7eccba5c5cc70d98657dccdc5cf935a9fd92934e74d6c0ffce0e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164e134801f7eccba5c5cc70d98657dccdc5cf935a9fd92934e74d6c0ffce0e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "57aad28e9489cc374ffd446e32f92c1eebf13294e601d169b293dea44345b14b"
    sha256 cellar: :any_skip_relocation, ventura:        "87ac993d1fa172a2e30ba894f7c7329f4c69a071c4cbb2b3f7b8fc4fdbddfa69"
    sha256 cellar: :any_skip_relocation, monterey:       "87ac993d1fa172a2e30ba894f7c7329f4c69a071c4cbb2b3f7b8fc4fdbddfa69"
    sha256 cellar: :any_skip_relocation, big_sur:        "87ac993d1fa172a2e30ba894f7c7329f4c69a071c4cbb2b3f7b8fc4fdbddfa69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bdbc4f522c64ed0bf539afbb6e48f43c96b1284d2a00416dd535706e140d373"
  end

  depends_on "ruby"

  # Ruby 3.3 introduced changes that mean we now need to manually require
  # racc. See https://bugs.ruby-lang.org/issues/19702 for details.
  # LicenseFinder versions after v7.1.0 may address this requirement.
  patch do
    url "https://github.com/pivotal/LicenseFinder/commit/4cac18e5c7a48f72700b8de4db97d3150637a20d.patch?full_index=1"
    sha256 "7a7a9b201cd34a5f868901841ba5f144f0e75580664c8ec024792449348f5875"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "license_finder.gemspec"
    system "gem", "install", "license_finder-#{version}.gem"
    bin.install libexec/"bin/license_finder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["GEM_PATH"] = ENV["GEM_HOME"] = testpath
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'license_finder', '#{version}'
      gem 'racc'
    EOS

    system "bundle", "install"
    assert_match "license_finder, #{version}, #{license}",
                  shell_output(bin/"license_finder", 1)
  end
end
