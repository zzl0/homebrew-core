class PythonPbr < Formula
  desc "Python Build Reasonableness"
  homepage "https://docs.openstack.org/pbr/latest/"
  url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
  sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  license "Apache-2.0"

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # https://docs.openstack.org/pbr/latest/user/packagers.html
    ENV["SKIP_GIT_SDIST"] = "1"
    ENV["SKIP_GENERATE_AUTHORS"] = "1"
    ENV["SKIP_WRITE_GIT_CHANGELOG"] = "1"
    ENV["SKIP_GENERATE_RENO"] = "1"

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    ENV["PBR_VERSION"] = version.to_s

    (testpath/"pyproject.toml").write <<~EOS
      [build-system]
      requires = ["pbr", "setuptools>=64.0.0"]
      build-backend = "pbr.build"
    EOS
    (testpath/"setup.cfg").write <<~EOS
      [metadata]
      name = test_package
      version = 0.1.0
    EOS
    pythons.each do |python|
      pyver = Language::Python.major_minor_version python
      system python, "-m", "pip", "install", *std_pip_args(prefix: testpath/pyver), "."
    end
  end
end
