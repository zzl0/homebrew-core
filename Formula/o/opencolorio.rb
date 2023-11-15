class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  stable do
    url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.3.0.tar.gz"
    sha256 "32b7be676c110d849a77886d8a409159f0367309b2b2f5dae5aa0c38f42b445a"

    # Backport fix for detection of yaml-cpp 0.8
    patch do
      url "https://github.com/AcademySoftwareFoundation/OpenColorIO/commit/1d3b69502eeb0f0b1d381d347efcab5b18ae9f3c.patch?full_index=1"
      sha256 "c57123c6e0c8541ac839b8e43f819aa93dbfbb436b3998bea5960496f5f6574b"
    end

    # Backport fix for detection of pystring
    patch do
      url "https://github.com/AcademySoftwareFoundation/OpenColorIO/commit/9078753990d7f976a0bfcd55cfa63f2e1de3a53b.patch?full_index=1"
      sha256 "ed9f39edcf1825102850554d00a811853cb2a2e30debe7fbae7388e220c27676"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "faefc0f5c3a10047cbce7d285d4fee3f559b119445769f3d5852fd5be50b9b8e"
    sha256 cellar: :any,                 arm64_ventura:  "24e90581137d74ea93eea49a901df620a6b6e2701b0c0093d2a11536e52759a4"
    sha256 cellar: :any,                 arm64_monterey: "53198ac5f3461fb2548af12babb164d6693749b2023cf064eb2f5ffd1b71ecc6"
    sha256 cellar: :any,                 arm64_big_sur:  "d074e606a1c3fec28b0d692c03aa88238074359ad47d56cf06887d9101b564cb"
    sha256 cellar: :any,                 ventura:        "c3c4653825daa64ab29a454b7fb03407f2b92b0982a4a77e44fbb7e5370c7842"
    sha256 cellar: :any,                 monterey:       "6ef1226d44426a9159f66d1ee39cbbc9b7954dda1c6f5167ae77e67bdc4a4c3d"
    sha256 cellar: :any,                 big_sur:        "233b55833ab1b80ab8a7265ac31fe2f63a48b83f885ee0128d00443ff213bf9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14827e687761b816cbeaab2471aba1791d23b080b8525123cbe09e4e78c23491"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "python@3.12"
  depends_on "yaml-cpp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def python3
    "python3.12"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DOCIO_BUILD_GPU_TESTS=OFF
      -DOCIO_BUILD_TESTS=OFF
      -DOCIO_INSTALL_EXT_PACKAGES=NONE
      -DOCIO_PYTHON_VERSION=#{Language::Python.major_minor_version python3}
      -DPython_EXECUTABLE=#{which(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
    system python3, "-c", "import PyOpenColorIO as OCIO; print(OCIO.GetCurrentConfig())"
  end
end
