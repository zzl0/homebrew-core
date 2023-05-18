class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://github.com/spglib/spglib/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "31bca273a1bc54e1cff4058eebe7c0a35d5f9b489579e84667d8e005c73dcc13"
  license "BSD-3-Clause"

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    # TODO: Fortran packaging is disabled for now because packaging does not pick it up properly
    # https://github.com/spglib/spglib/issues/352#issuecomment-1784943807
    common_args = %w[
      -DSPGLIB_WITH_Fortran=OFF
    ]
    system "cmake", "-S", ".", "-B", "build_shared",
                   *common_args, "-DSPGLIB_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static",
                  *common_args, "-DSPGLIB_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"
  end

  test do
    (testpath / "test.c").write <<~EOS
      #include <stdio.h>
      #include <spglib.h>
      int main()
      {
        printf("%d.%d.%d", spg_get_major_version(), spg_get_minor_version(), spg_get_micro_version());
      }
    EOS

    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C)
      find_package(Spglib CONFIG REQUIRED COMPONENTS shared)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_shared"
    system "cmake", "--build", "build_shared"
    system "./build_shared/test_c"

    (testpath / "CMakeLists.txt").delete
    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C Fortran)
      find_package(Spglib CONFIG REQUIRED COMPONENTS static)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_static"
    system "cmake", "--build", "build_static"
    system "./build_static/test_c"
  end
end
