class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v1.2.3",
      revision: "4bd38da318ec54af8e2d8d5d0bdbd5eb9bc0784f"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af49d3c22a8cb1c8d872f6e46956e50eb68733ce23097ff872f69c5886f0721f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "089f8b1956603b44a20db21c0b912306f0c18312e64ad08a42222b0bea4605e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0975b622460f237086b287799f9c233db85142e260c781336df31c02485d4e23"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e7620de736994b87dc70adf81ad1f4fc89f6b503162e4a7046fc2e9f97b1e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f58738f31bebfb2df67565c3029fcf626aa456727d0660d8773722ae730fffde"
    sha256 cellar: :any_skip_relocation, monterey:       "85286c3cd9484df1f9372b81b125e483a50cc10a12b0980784e2fb0963c8dcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c8c8a637e750c68972f7faa1e058d75677e8e9142bc70bd057482c1a08dffc"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <prometheus/registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
