class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "7196e979a0449ce28afd46a78383476f3b8fc1cc1d3a417192be439ede83437b"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a4b8a52b3da9cc5fcd1adc0d5c0143b0b579b60d07990ca5ad5fe19b8d4d2b4"
    sha256 cellar: :any,                 arm64_ventura:  "f5dc959b648f0df4e5b674cbf9a7ef504777c96b9cb5509aced1bece54dc14cc"
    sha256 cellar: :any,                 arm64_monterey: "ea1f81fd2aa4fabfa0afe3e7150586004a2ae8cadd3859a1809b5ea857152af4"
    sha256 cellar: :any,                 sonoma:         "0e066c04dd6178becebaeb1cc85738fe4aaac670e7fd77477aefc650f9bd3a20"
    sha256 cellar: :any,                 ventura:        "11a61e056d96987bc8f825183a31c709a6a913b4a59cd709983ae5837c0d6000"
    sha256 cellar: :any,                 monterey:       "f470717b782952115cb7116a0c5c1a9dcffb33ad826863d8b6362290b6d87c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb4c90738d4ff25c4669a9dc44b28062c4ce2ff28fb612166985a3d87a6ba6e"
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

  # upstream issue report, https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1920
  patch :DATA

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

__END__
diff --git a/src/OpenColorIO/ConfigUtils.cpp b/src/OpenColorIO/ConfigUtils.cpp
index 2e77472..b4228ff 100644
--- a/src/OpenColorIO/ConfigUtils.cpp
+++ b/src/OpenColorIO/ConfigUtils.cpp
@@ -3,7 +3,7 @@

 #include "ConfigUtils.h"
 #include "MathUtils.h"
-#include "pystring/pystring.h"
+#include "pystring.h"
 #include "utils/StringUtils.h"

 namespace OCIO_NAMESPACE
