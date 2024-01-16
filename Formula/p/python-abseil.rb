class PythonAbseil < Formula
  desc "Abseil Common Libraries (Python)"
  homepage "https://abseil.io/docs/python/"
  url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
  sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef53363a3f0455d8c6d9c19943a4b89017bd47bb205b7b211f984080e2f0f947"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba42acce01bd0c61317d487fe76ab4aa492fb0e0fb4666aa55694173c9da1d32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd650a61e2a5949741b6d95677966cac9614e2af96afd324d74b8832a155f98a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9595e5f1aa9a78b8a0d6a8f7281c1812d662957611d0e39781aada5008155f75"
    sha256 cellar: :any_skip_relocation, ventura:        "3f0b3eef6f23c70f4c981a15b852e5ce6d088862d439a03de4c58958421a19f0"
    sha256 cellar: :any_skip_relocation, monterey:       "d96a9627a24b18a66cf9e1c76bfddd3b2aca056c890cddec9d9c4a65a9c70e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f862a091de488546a9bbb0941d73c3206f2acc0137d977a7e9dd4489113901"
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
      system python_exe, "-c", "from absl import app"
    end
  end
end
