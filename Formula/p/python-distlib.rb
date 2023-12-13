class PythonDistlib < Formula
  desc "Library which implements some Python packaging standards (PEPs)"
  homepage "https://distlib.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
  sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13f431698978d112db9b66feaef6a202520c5b15b171af63d3b4d7858d0a3bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2610dd0496df18796f59f41a0d41d14b7e9e10b4e33c6a171c99323d4a5e3a18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fffe57397af77d6e824707f96cef29f0694026af701b0058c6ee14aa0be20466"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e085359879851783fd6fe481d359b5aba2600067c640cbd1376ea959fde5545"
    sha256 cellar: :any_skip_relocation, ventura:        "204acae1e913121938f0b96b303b905acff9907ada1b7924f6e0b747984c9144"
    sha256 cellar: :any_skip_relocation, monterey:       "2275b8c44973602c10346fec3bd89c4fdb512576fba759a4ffae388ccc48fe61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f63fb5b8744a1056ae9baefb09334aa6b2f217752964e4c1e95fd9ff7bbd46e"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from distlib.database import DistributionPath"
    end
  end
end
