class Limesuite < Formula
  desc "Device drivers utilities, and interface layers for LimeSDR"
  homepage "https://myriadrf.org/projects/software/lime-suite/"
  url "https://github.com/myriadrf/LimeSuite/archive/refs/tags/v23.10.0.tar.gz"
  sha256 "3fcbc4a777e61c92d185e09f15c251e52c694f13ff3df110badc4ed36dc58b00"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gnuplot"
  depends_on "libusb"
  depends_on "soapysdr"
  uses_from_macos "sqlite"

  def install
    args = %W[
      -DENABLE_OCTAVE=OFF
      -DENABLE_SOAPY_LMS7=ON
      -DENABLE_STREAM=ON
      -DENABLE_GUI=ON
      -DENABLE_DESKTOP=ON
      -DENABLE_LIME_UTIL=ON
      -DENABLE_QUICKTEST=ON
      -DENABLE_NOVENARF7=ON
      -DENABLE_MCU_TESTBENCH=OFF
      -DENABLE_API_DOXYGEN=OFF
      -DDOWNLOAD_IMAGES=TRUE
      -DLIME_SUITE_EXTVER=release
      -DLIME_SUITE_ROOT='#{HOMEBREW_PREFIX}'
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Checking driver 'lime'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=lime")
  end
end
