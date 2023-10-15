class PythonPsutil < Formula
  desc "Cross-platform lib for process and system monitoring in Python"
  homepage "https://github.com/giampaolo/psutil"
  url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
  sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bacf974d03ba13e2a9dadad270468fd1be8e221fd58d43e80374bc7b216278f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7615ce4070e504d865bdc3ea3cdeec333727874027de9c3b8622505d031ceadf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2634b0112bb7b29c5f7e4a147ab30be8081853292117003e104f2f9587ebf3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "17ac126cb379e5fa1bafe3c3211917c7d59b7ddecec1bc15801a2058a1d4e0c4"
    sha256 cellar: :any_skip_relocation, ventura:        "c13071b3bbf94cc205ff68c0dc5c9732f41bb4de4bf4d3943e511431956a2e3b"
    sha256 cellar: :any_skip_relocation, monterey:       "91617ac5389d77a8ce567e953ba173c0d73c15bd000b05e0f5fca751c7654125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0119f04d5a1b1196d788fe54b8c31fcde5f79e6389b288dab9f24f7fd7272c6"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import psutil"
    end
  end
end
