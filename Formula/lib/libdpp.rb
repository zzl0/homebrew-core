class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.0.29/DPP-10.0.29.tar.gz"
  sha256 "a37e91fbdabee20cb0313700588db4077abf0ebabafe386457d999d22d2d0682"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "9f05a962b1a82a872ffff8ac3ab084f762ce85b1bd076412164efa98f0d452c8"
    sha256 cellar: :any, arm64_ventura: "0fa3f044e825df1976c3693c711d4c0e0167d1e4f039f46ad949b6e603d1fd68"
    sha256 cellar: :any, sonoma:        "6d3235f0f8c9bfd0ec3ed8be0266021e3c30b25c6414014d4eacd5781dfd1187"
    sha256 cellar: :any, ventura:       "6741fe146953c539d511e6687a03dde30b0721e695eef7c1be3fdf14967d8d50"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["12.0", :build]
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pkg-config"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDPP_CORO=on", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dpp/dpp.h>

      int main() {
        dpp::cluster bot("invalid_token");

        bot.on_log(dpp::utility::cout_logger());

        try {
          bot.start(dpp::st_wait);
        }
        catch(dpp::invalid_token_exception& e) {
          std::cout << "Invalid token." << std::endl;
          return 0;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-ldpp"
    assert_equal "Invalid token.", shell_output("./test").strip
  end
end
