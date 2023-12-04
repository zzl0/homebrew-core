class GlbindingAT2 < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "cb5971b086c0d217b2304d31368803fd2b8c12ee0d41c280d40d7c23588f8be2"
  license "MIT"

  keg_only :versioned_formula

  depends_on "cmake" => :build

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Force install to use system directory structure as the upstream only
    # considers /usr and /usr/local to be valid for a system installation
    inreplace "CMakeLists.txt", "set(SYSTEM_DIR_INSTALL FALSE)", "set(SYSTEM_DIR_INSTALL TRUE)"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DOPTION_BUILD_TESTS=OFF",
                    "-DOPTION_BUILD_GPU_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
    EOS
    open_gl = OS.mac? ? ["-framework", "OpenGL"] : ["-L#{Formula["mesa-glu"].lib}", "-lGL"]
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11",
                    "-I#{include}", *open_gl,
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
