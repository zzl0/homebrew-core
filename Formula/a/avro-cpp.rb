class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  # Upstreams tar.gz can't be opened by bsdtar on macOS
  # https://github.com/Homebrew/homebrew-core/pull/146296#issuecomment-1737945877
  # https://apple.stackexchange.com/questions/197839/why-is-extracting-this-tgz-throwing-an-error-on-my-mac-but-not-on-linux
  url "https://github.com/apache/avro.git",
      tag:      "release-1.11.3",
      revision: "35ff8b997738e4d983871902d47bfb67b3250734"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4d56f71adcff72a88f4ef6f20d023676fbcad8e495bee1d306d1112011610cf"
    sha256 cellar: :any,                 arm64_ventura:  "b3f08fe9f4adb2c7d738375b67bf7e8714e0545f6f06aea7e3dcd71e5a063056"
    sha256 cellar: :any,                 arm64_monterey: "59974b029bc5ddeb8bfda48c65654a4234eb93da7a906550bfec01bc0f0ca17f"
    sha256 cellar: :any,                 arm64_big_sur:  "ff389dcf51bea64a046460954b87aafd3c8aae34a91f0aa6abe5195fe7497b9f"
    sha256 cellar: :any,                 sonoma:         "e33df9230b9b861a3dc68402c0f42b2a72a8ac6cb866bf37f2f1423d93a0df89"
    sha256 cellar: :any,                 ventura:        "4b716a1ad09b16035c828d56009ba448f5900b8f5d45b1a1203cb187f4915d73"
    sha256 cellar: :any,                 monterey:       "7cfdaa40cb85377a7381c36156c9170b0e9d73c74f2e9e21b6907a10d71ba4c8"
    sha256 cellar: :any,                 big_sur:        "6d8c3060dc59bf18609c4460083ce0e249667841c167729fbbc78cdf849248fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "424e21b1c2105bd4cb1856dda9dc4ed7f94a16e666b1b58ea887345bed28dafb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    cd "lang/c++" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
