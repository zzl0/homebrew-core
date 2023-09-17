class Yder < Formula
  desc "Logging library for C applications"
  homepage "https://babelouest.github.io/yder/"
  url "https://github.com/babelouest/yder/archive/refs/tags/v1.4.20.tar.gz"
  sha256 "c1a7f2281514d0d0bba912b6b70f371d8c127ccfd644b8c438c9301a0fd4c5f2"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "orcania"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd"
  end

  def install
    args = %w[
      -DDINSTALL_HEADER=ON
      -DDBUILD_YDER_DOCUMENTATION=ON
    ]

    args << "-DWITH_JOURNALD=OFF" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <yder.h>

      int main() {
        y_init_logs("HelloYder", Y_LOG_MODE_CONSOLE, Y_LOG_LEVEL_DEBUG, NULL, "Starting Hello World with Yder");
        y_log_message(Y_LOG_LEVEL_INFO, "Hello, World!");
        y_close_logs();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lyder", "-o", "test"
    system "./test"
  end
end
